docker run -it whypro/fio --bs=4k --ioengine=libaio --iodepth=32 --direct=1 --rw=rw --time_based --runtime=60  --refill_buffers --norandommap --randrepeat=0 --group_reporting --name=fio-rw --size=10M --filename=fio.test