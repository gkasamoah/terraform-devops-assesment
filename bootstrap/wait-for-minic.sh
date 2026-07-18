
 #!/bin/bash

until curl -f http://localhost:9000/minio/health/live
do
    sleep 2
done