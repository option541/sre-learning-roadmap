import time
from datetime import datetime

while True:
    now = datetime.now()

    print(
        f"{now} SRE demo service running",
        flush=True
    )

    time.sleep(10)
