--- FILLING TO FULL ---
Time:  20 | wr_en:1 rd_en:0 | din: 10 dout:  0 | count: 0 | full:0 empty:1
Time:  30 | wr_en:1 rd_en:0 | din: 10 dout:  0 | count: 1 | full:0 empty:0
Time:  40 | wr_en:1 rd_en:0 | din: 30 dout:  0 | count: 2 | full:0 empty:0
Time:  50 | wr_en:1 rd_en:0 | din: 30 dout:  0 | count: 3 | full:0 empty:0
Time:  60 | wr_en:1 rd_en:0 | din: 50 dout:  0 | count: 4 | full:0 empty:0
Time:  70 | wr_en:1 rd_en:0 | din: 50 dout:  0 | count: 5 | full:0 empty:0
Time:  80 | wr_en:1 rd_en:0 | din: 70 dout:  0 | count: 6 | full:0 empty:0
Time:  90 | wr_en:1 rd_en:0 | din: 70 dout:  0 | count: 7 | full:0 empty:0

--- ATTEMPT EXTRA WRITE (99) ---
Time: 100 | wr_en:0 rd_en:0 | din: 80 dout:  0 | count: 8 | full:1 empty:0
Time: 110 | wr_en:0 rd_en:0 | din: 80 dout:  0 | count: 8 | full:1 empty:0

--- DRAINING TO EMPTY ---
Time: 120 | wr_en:0 rd_en:0 | din: 99 dout:  0 | count: 8 | full:1 empty:0
Time: 130 | wr_en:0 rd_en:1 | din: 99 dout:  0 | count: 8 | full:1 empty:0
Time: 140 | wr_en:0 rd_en:1 | din: 99 dout: 10 | count: 7 | full:0 empty:0
Time: 150 | wr_en:0 rd_en:1 | din: 99 dout: 20 | count: 6 | full:0 empty:0
Time: 160 | wr_en:0 rd_en:1 | din: 99 dout: 30 | count: 5 | full:0 empty:0
Time: 170 | wr_en:0 rd_en:1 | din: 99 dout: 40 | count: 4 | full:0 empty:0
Time: 180 | wr_en:0 rd_en:1 | din: 99 dout: 50 | count: 3 | full:0 empty:0
Time: 190 | wr_en:0 rd_en:1 | din: 99 dout: 60 | count: 2 | full:0 empty:0
Time: 200 | wr_en:0 rd_en:1 | din: 99 dout: 70 | count: 1 | full:0 empty:0

--- ATTEMPT EXTRA READ ---
Time: 210 | wr_en:0 rd_en:0 | din: 99 dout: 80 | count: 0 | full:0 empty:1
Time: 220 | wr_en:0 rd_en:0 | din: 99 dout: 80 | count: 0 | full:0 empty:1

Smoke test complete.
Time: 230 | wr_en:0 rd_en:0 | din: 99 dout: 80 | count: 0 | full:0 empty:1
design.sv:87: $finish called at 240 (1s)
Time: 240 | wr_en:0 rd_en:0 | din: 99 dout: 80 | count: 0 | full:0 empty:1