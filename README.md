# VA Mobile Navigation App

**In this project for CS 599, we will develop a mobile navigation iOS app for the patients of the VA to use.**

_member’s GitHubIDs (Names): MetaJT (Jordan Trotter), greentyler111 (Steven Janssen), jt2104 (Jackson Tran)_

## BLE Sensor Research
_Goal: Find a reliable Low Energy Bluetooth beacon that we can use for a sense of location while indoors_
1. ~~[FEASYCOM](https://www.amazon.com/programmable-Battery-Bluetooth-eddystone-Technology/dp/B078N2B7RD/ref=asc_df_B078N2B7RD/?tag=hyprod-20&linkCode=df0&hvadid=241965663546&hvpos=&hvnetw=g&hvrand=10042743716919065296&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9024247&hvtargid=pla-486845475033&psc=1&mcid=28dd533fdf473f068e4a01772e7c6224&gclid=CjwKCAiA29auBhBxEiwAnKcSqoCoc_4hhqeMp5lkZ-stfxS8rYdn4bvepKq2QtAFktOopiRQPy92ORoCDMQQAvD_BwE)~~

2. ~~[FEASYCOM FSC-BP103B](https://www.amazon.com/FeasyBeacon-Bluetooth-Proximity-Eddystone-programmable/dp/B077FQ6HLV/ref=pd_bxgy_img_d_sccl_1/137-3622995-4362555?pd_rd_w=fcy5M&content-id=amzn1.sym.2b132e63-5dcd-4ba1-be9f-9e044543d59f&pf_rd_p=2b132e63-5dcd-4ba1-be9f-9e044543d59f&pf_rd_r=W9MXSF1CERJC91764HKN&pd_rd_wg=vvO0c&pd_rd_r=61e169f2-adaa-4c79-befe-1e0b5400c89b&pd_rd_i=B077FQ6HLV&psc=1)~~

3. ~~[Blue Charm Beacons - BC05](https://www.amazon.com/dp/B0CLN34NHK?ref=emc_s_m_5_i_n)~~

4. [Blue Charm Beacons - BCO04P](https://www.amazon.com/dp/B0BMY36FQ1?ref=emc_s_m_5_i_n)
   - From Amazon
   - Price: $21.95
   - Range: "150m"
   - Supports iBeacon
   - Lithium-Ion battery(CR2477) "4 year life"
   - 4.4/5 stars from 4 ratings and 2 positive reviews
   - **Think this might be the best option**
5. ~~[Blue Charm Beacnos - BC063B](https://www.amazon.com/Blue-Charm-Beacons-Water-Resistant-BC063B-iBeacon/dp/B07Z1FR6GY/ref=sr_1_10?crid=MUL1TEHMUN8Z&dib=eyJ2IjoiMSJ9.HqGVwXxaQ0RaD0v7qTlpKwYJaUw3AmSz610Z_4E7o6gsm9NaA4heTWCGYC8EuupquQ_gb-mgK4beIfwYUy86_xvZuXhGcLcp9aluBQw-PfIjSOrsDIMZaB1RQQ-p4H-jfMghZcIxAJphUrR-ELUOMQ.8kzVhwEGBgdhF4yJTWfucgKRqsBhB_YIkeFLO8NL_p0&dib_tag=se&keywords=Bluetooth+BLE+iBeacon+%28BC037S-SmoothPattern-iBeacon%29&qid=1708540770&sprefix=bluetooth+ble+ibeacon+bc037s-smoothpattern-ibeacon+%2Caps%2C189&sr=8-10)~~

## Existing Indoor Navigation Sources
_Goal: Find publicly accessible indoor positioning sources to utilize if needed, as creating our own may not be plausible within this time frame_
1. [FIND Framework](https://github.com/schollz/find3.git)
   - Supports bluetooth
   - May **only** support Android, according to an older version
2. [BLE Indoor Positioning Library](https://github.com/neXenio/BLE-Indoor-Positioning.git)
   - Utilizes bluetooth beacons 
3. [Navigine SDK](https://github.com/Navigine/Indoor-Navigation-iOS-Mobile-SDK-2.0.git)
   - Exclusively for iOS
   - No mentions of bluetooth compatibility
   - The most up-to-date repo out of all three
