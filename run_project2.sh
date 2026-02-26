Script started on 2026-02-20 17:28:55-05:00
bash-4.4$ c[Kls
Amazon.csv  challenge2.txt  count.txt  hello.txt  log.txt  recordSample.txt  test.txt
bash-4.4$ mkdir -p data/samples
bash-4.4$ mkdir -p data/samples[C[C[C[C[C[C[C[C[C[Cls[Kpwdgit push -u origin "$BRANCH"[C[C[C[C[C[C[C[C[C[CBRANCH="$(git branch --show-current)"[C[C[C[C[C[C[C[C[C[Cgit commit -m "HW03: UNIX data wrangling" [C[C[C[C[C[C[C[C[C[C[C[C[C[Cstatus[Krm --cached hw03/amazon_reviews_10k_mystery.tsv[C[C[C[C[C[C[C[C[C[C[C[C[C[Cstatus[Krm --cached hw03/amazon_reviews_10k_mystery.tsv[C[C[C[C[C[C[C[C[C[C[C[C[C[Cstatus[Kcommit -m "HW03: UNIX data wrangling" [C[C[C[C[C[C[C[C[C[C[5PBRANCH="$(git branch --show-current)"[C[C[C[C[C[C[C[C[C[C[9Pgit push -u origin "$BRANCH"[C[C[C[C[C[C[C[C[C[Cpwd[K[1Plsmkdir -p data/samples[C[C[C[C[C[C[C[C[C[C[Khead -n 1 Amazon.csv ? [K[K> data/samples/Amazon_sample_1k.csv[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[KRandom_Amz[Ka[K[K[K[K[K[K[K[K[K[KAmazon_random[K[Kom_1k.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv1.csvk.csv_.csvs.csva.csvm.csvp.csvl.csve.csvRsample.csv[C[C[C[C[C[C[C[C[C[C[1Psample.csv[1Psample.csv[1Psample.csvksample.csv[C[C[C[C[C[C[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csvr.csva.csvn.csvd.csvo.csvm.csv1.csvk.csv[1P.csv[1P.csv_.csv1.csvk.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csv[1P.csvr.csva.csvd.csvn.csvo.csvm.csv[1P.csv[1P.csv[1P.csv[1P.csvn.csvd.csvo.csvm.csv_.csv1.csvk.csv[C[C_.csvA.csvm.csva.csvz.csvo.csvn.csv[C[C[C[C
bash-4.4$ tail -n +2 Amazon.csv [K sr[Kort -R | head -n 1000 >> data/samples/Amazon[K[K[K[K[K[Krandom_1k_Amazon.csv 
tail: invalid option -- 'R'
Try 'tail --help' for more information.
bash-4.4$ tail -n +2 Amazon.csv sort -R | head -n 1000 >> data/samples/random_1k_Amazon.csv [C[C[C[1@|[1@ 
bash-4.4$ cd data/sampple[K[K[Kles
bash-4.4$ ls
random_1k_Amazon.csv
bash-4.4$ wc -l random_1k_Amazon.csv 
1001 random_1k_Amazon.csv
bash-4.4$ head -n 5 A[Krandom_1k_Amazon.csv 
OrderID,OrderDate,CustomerID,CustomerName,ProductID,ProductName,Category,Brand,Quantity,UnitPrice,Discount,Tax,ShippingCost,TotalAmount,PaymentMethod,OrderStatus,City,State,Country,SellerID
ORD0082999,2023-07-17,CUST045900,Aarav Singh,P00015,Instant Pot,Electronics,BrightLux,5,510.05,0.15,108.39,11.27,2287.37,Amazon Pay,Pending,Chicago,IL,India,SELL00102
ORD0012273,2023-02-01,CUST046344,Aarav Patel,P00041,Webcam Full HD,Clothing,UrbanStyle,5,367.94,0.15,125.1,0.27,1689.11,Cash on Delivery,Delivered,Philadelphia,PA,United States,SELL00126
ORD0042111,2023-12-22,CUST035606,Ritika Gupta,P00022,Water Bottle,Books,BrightLux,4,541.48,0.2,311.89,7.36,2051.99,Credit Card,Delivered,Dallas,TX,India,SELL01116
ORD0021036,2021-04-28,CUST041374,Mohit Sharma,P00010,Smartwatch,Toys & Games,KiddoFun,3,588.55,0.05,134.19,9.0,1820.56,Amazon Pay,Delivered,Austin,TX,United States,SELL00508
bash-4.4$ exit

Script done on 2026-02-20 17:33:20-05:00
#!/bin/bash

# our dataset is called Amazon.csv and is located inside of /mnt/scratch/CS131_jelenag/projects/team04_sec1
# our random 1k sample is located in the data/samples/random_1k_Amazon.csv and the session was recorded in recordSample.txt 
# we have all of our outputs saved inside of out/

mkdir -p out

# frequency table using discount and date
tail -n +2 data/samples/random_1k_Amazon.csv | cut -d, -f2,11 | sort | uniq -c | sort -nr | tee out/freq_discountdate.txt 

# frequency table using order status
tail -n +2 data/samples/random_1k_Amazon.csv | cut -d, -f16 | grep -vi "pending" | sort | uniq -ic | sort -nr > out/freq_orderstatus.txt 2> out/errors.txt 

# frequency table using unit price and tax 
tail -n +2 data/samples/random_1k_Amazon.csv | cut -d, -f10,12 | sort | uniq -c | sort -nr > out/freq_pricetax.txt 

#top-N using product id
cut -d, -f5 Amazon.csv | tail -n +2 | sort -f | uniq -ci | sort -nr | head -10 > out/topN_product_id.txt

#skinny table using city and state
cut -d, -f17,18 Amazon.csv | tail -n +2 | sort -fu > out/skinny_table_city_state.txt

