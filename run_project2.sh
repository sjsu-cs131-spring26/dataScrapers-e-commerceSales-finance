# Script recordSample.txt 
Script started on 2026-02-26 01:00:22-05:00
bash-4.4$ pwd
/mnt/scratch/CS131_jelenag/projects/team04_sec1
bash-4.4$ mkdir -p data/samples
bash-4.4$ head -n 1 Amazon.csv > data/samples/Amazon_sample_2k[K[K1k.csv
bash-4.4$ tail -n + 2[K[K2[K[K[K[K[K[K[K[K[K[Kls data/samples
Amazon_sample_1k.csv
bash-4.4$ cat data/samples/Amazon_saml[Kple_1k..cs[K[K[Kcsv
OrderID,OrderDate,CustomerID,CustomerName,ProductID,ProductName,Category,Brand,Quantity,UnitPrice,Discount,Tax,ShippingCost,TotalAmount,PaymentMethod,OrderStatus,City,State,Country,SellerID
bash-4.4$ tail -n +2 Amazon_[K.csv | sort -R|[K | head -n 10000[K >> data/samples/Aa[Kmazon_sample_1k.t[Kcsv
cd da     bash-4.4$ ks[K[Kls
Amazon.csv	data				      log.txt		      run_project2.sh
challenge2.txt	dataScrapers-e-commerceSales-finance  project_assignment2.sh  team04_sec1
count.txt	hello.txt			      projects2.session.txt   test.txt
bash-4.4$ cd data/samples
bash-4.4$ ls
Amazon_sample_1k.csv
bash-4.4$ exit

Script done on 2026-02-26 01:02:44-05:00
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

