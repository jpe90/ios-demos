(print "What what")
# Create a server on localhost and listen on port 8000.
(def my-server (net/listen "127.0.0.1" "8000"))

(defn handler
  "Handle a connection in a separate fiber."
  [connection]
  (defer (:close connection)
    (def msg (ev/read connection 100))
    (ev/sleep 1)
    (print "server received message: " msg)
    (net/write connection (string "Hello from server! Echo: " msg))))

# Handle connections as soon as they arrive
(forever
 (def connection (net/accept my-server))
 (ev/call handler connection))
