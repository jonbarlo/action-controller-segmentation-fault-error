class TestController < ActionController::Base
  include ActionController::Live
  
  def index
    # This is where the crash might occur
    response.headers['Content-Type'] = 'text/plain'
    response.headers['Cache-Control'] = 'no-cache'
    
    begin
      # Create database connections to trigger the race condition
      create_test_connections
      
      # Simulate streaming response
      response.stream.write "Processing request in thread #{Thread.current.object_id}\n"
      
      # Add delay to increase race condition probability
      sleep(rand(0.01..0.05))
      
      response.stream.write "Request completed in thread #{Thread.current.object_id}\n"
      response.stream.close
      
    rescue => e
      puts "Error in controller: #{e.class}: #{e.message}"
      response.stream.close if response.stream
    end
  end
  
  private
  
  def create_test_connections
    # Create multiple PostgreSQL connections to trigger the crash
    connections = []
    
    3.times do |i|
      begin
        conn = PG.connect(
          host: 'postgres',
          port: 5432,
          dbname: 'postgres',
          user: 'postgres',
          password: 'postgres'
        )
        
        connections << conn
        
        # Execute a query to keep connection active
        conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid")
        
      rescue => e
        puts "Error creating connection #{i}: #{e.class}: #{e.message}"
      end
    end
    
    # Simulate the race condition: multiple threads accessing the same connection
    if connections.any?
      connections.each do |conn|
        Thread.new do
          begin
            # Wait for the exact moment to create the race condition
            sleep(rand(0.001..0.005))
            
            # This is where the crash should happen: concurrent access
            conn.exec("SELECT 1 as test")
            
            # Simulate the "double concurrent PG#close" scenario
            if rand < 0.3
              2.times do
                Thread.new do
                  begin
                    sleep(rand(0.0001..0.001))
                    conn.close  # This should trigger the crash
                  rescue => e
                    puts "Error closing connection: #{e.class}: #{e.message}"
                  end
                end
              end
            end
            
          rescue => e
            puts "Error in race condition thread: #{e.class}: #{e.message}"
          end
        end
      end
    end
  end
end
