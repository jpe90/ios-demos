(with [conn (net/connect "0.0.0.0" "8000" :stream)]
  (printf "Connected to %q!" conn)
  (:write conn "Hello from client!")
  (print "Wrote to connection...")
  (def res (:read conn 1024))
  (pp res))
