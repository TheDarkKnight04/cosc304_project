CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId),
    FOREIGN KEY (state) REFERENCES taxrates(state)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    customerId          INT,
    productId           INT,
    quantity            INT,  
    PRIMARY KEY (customerId, productId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE taxrates (
    state VARCHAR(20),
    pst INT,
    gst INT,
    hst INT,
    PRIMARY KEY (state)
);

INSERT INTO taxrates(state, pst, gst, hst) VALUES ('AB', 0, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('BC', 7, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('MB', 7, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('NB', 0, 0, 15);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('NL', 0, 0, 15);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('NT', 0, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('NS', 0, 0, 15);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('NU', 0, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('ON', 0, 0, 13);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('PE', 0, 0, 15);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('QC', 9.975, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('SK', 6, 5, 0);
INSERT INTO taxrates(state, pst, gst, hst) VALUES ('YT', 0, 5, 0);

INSERT INTO category(categoryName) VALUES ('Skis');
INSERT INTO category(categoryName) VALUES ('Snowboards');
INSERT INTO category(categoryName) VALUES ('Jackets');
INSERT INTO category(categoryName) VALUES ('Ski Boots');
INSERT INTO category(categoryName) VALUES ('Snowboard Bindings');
INSERT INTO category(categoryName) VALUES ('Helmets');
INSERT INTO category(categoryName) VALUES ('Apparel');
INSERT INTO category(categoryName) VALUES ('Goggles');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Arc''teryx Women''s Atom Hoody',3,'Steeped in the alpine, this versatile hoody has warmed climbers, hikers, backcountry skiers and downtown commuters. Worn as a midlayer or standalone, it performs across a range of conditions and output levels. Coreloft™ Compact insulation retains warmth even if wet and has loft retention that withstands years of packing and unpacking. The water resistant Tyono 20 face fabric is soft, breathable and durable, stretch side panels improve ventilation and freedom, and the insulated StormHood adds warmth.',359.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armada ARV 100 Ski 2023/24', 1, 'An entirely new creation, the ARV 100 is the all-mountain freestyle king with a 100mm waist and AR Freestyle Rocker providing exceptional all-around versatility. Whether sending it in the park or charging around the mountain in search of a few inches of fresh snow, the wider platform and rocker in the tips and tails deliver a solid platform for rutted out landings and variable conditions. The ultralight Caruba Core keeps the weight to a minimum, enabling bigger tricks with less effort, while the w3Dgewall construction ensures bombproof durability. With the softest flex profile of the new ARV Series, the ARV 100 is the ski of choice for butters and presses inside the park and out. Ski anywhere you like any way you want. The ARV 100 has your back.',359.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armada ARW 94 Ski 2023/24 ',1,'Meet the new boss. The ARW 94 is the centerpiece of Armada''s new ARW Series, combining a playful flex profile with plenty of pop and stability to shred any corner of the park. The ARW 94 utilizes our lightest Caruba Core to keep weight to a minimum, while the 3D molded, injected w3Dgewall construction delivers maximum durability to outlast other skis. AR Freestyle Rocker in the tips and tails enhances versatility in a variety of conditions, placing all-mountain shredding squarely in the ARW 94’s comfort zone. Pairing peak performance and maximum durability, the ARW 94 can shred everything all season long.', 749.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Utility 2L Insulated Jacket ',3,'The Utility Jacket combines military-inspired style cues with a tough, technical construction for a unique look and durable performance on the hill. 84% nylon, 16% elastane fabric backed by 60g of quilted insulation keeps you warm and dry with 10K/10K protection and enough stretch to move any way you want. It has all the pockets, including two zip front chest pockets to keep items extra secure and a pair of multi-functional handwarmer pockets to stow gear and keep your digits warm. Details like a powder skirt, wrist gaiters, and cinches at the hood and hem seal out the elements. When there''s plenty of items you can''t leave home without, don''t leave home without the Utility Jacket.',419.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Black Crows Mirus Cor Ski 2023/24 ',1,'The Mirus Cor is a ski object born of performance and design, to achieve an alliance between two worlds: freestyle and the most angular carves of the moment. Built with a long rocker tip and tail, it can be skied short to play with piste and the most playful sidehits. It is carving in a blackcrows way, a true freestyle all terrain. Accessible, solid and creative in every respect. The Cor blackcrows acronym is displayed on products that seek to disrupt the practice and push the innovation on the snow. With no boundaries.',1299.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Blizzard Black Pearl 88 Ski 2023/24 ',1,'If you are looking for a ski that rips on groomers and cuts through crud but won''t bog you down in fresh snow, the Black Pearl 88 is your tried and true. The 88mm-waisted ski provides an unmatched level of versatility for intermediate to advanced skiers but is also strong enough for expert skiers who like to up the ante. Each ski is specifically designed by size to give that individual skier the experience they''re after, whether it''s casual cruising or laying it down. The TrueBlend Flipcore with a Women''s Specific Design provides stability and strength, with a sidecut that can easily rotate between short, medium or long radius turns. Click in, have some fun and show ''em who''s boss.',849.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Blizzard Rustler 10 Ski 2023/24 ',1,'The Rustler 10 has long been praised as the holy grail of freeride skis, and while that''s quite the claim to hang your hat on, we''ve never been the type to settle. Which is exactly why we''ve gone back to drawing board on the Rustler, with the not-so-simple goal of making the best better. Completely redesigned, the quiver-killer is back with a vengeance, fueled by an energetic Freeride Trueblend woodcore and an all-new FluxForm metal layup technology. Trueblend and FluxForm are designed to work together to provide stability and strength underfoot, yet retain all of the playfulness you''ve come to love and expect in the tip and tail of a Rustler 10. From hunting glory pow in the trees to showing off under the lift, now more than ever, the Rustler 10 is built to Press Send.',849.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Faction Prodigy 2 Ski 2023/24 ',1,'The Faction Prodigy 2 is the ultimate all-mountain freestyle ski. The poplar wood core is soft and poppy enough to butter over rollers while the 98 mm waist width, directional twin shape and eliptical sidecut give you the confidence the shred all over the mountain in any snow condition.',699.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Faction Studio 1X Ski 2023/24 ',1,'The Faction Studio 1X was designed in collaboration with Faction''s stacked freestyle athlete roster to engineer a park specific freestyle ski that delivers precision performance with effortless, oozing style. Featuring a poplar and ash core for the ideal blend of lightweight spring and rigid power while the carbon reinforcement under the binding area help withstand heavy stomps. The symmetrical shape allows for effortless switch skiing, while the carbon weave provides torsional strength without added bulk and the 7mm XL sidewall delivered supreme edge hold and protection of the wood core. The Studio 1X has an alternate topsheet to the Studio 1, designed to celebrate women in skiing.',849.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Cold Shoulder Snowboard 2023/24 ',2,'Designed for the intermediate- to- expert snowboarder, the K2 Cold Shoulder features a Combination Camber profile that places camber in between the feet for snap, stability, and adds rocker profile outside the bindings for playful and intuitive turn initiation. A small amount of rise in the tail helps keep the board lively and predictable, while a long-extended rocker profile in the tip helps to ease turn initiation and float in powder.',569.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Mindbender 106C Ski 2023/24',1,'The all-new K2 Mindbender 106C redefines all-mountain performance in a weight conscious and playful package. Purpose-engineered to excel in a variety of conditions while maintaining playful maneuverability and stability. Strapped with patented Spectral Braid Technology, first-of-its-kind variable-angle fiber reinforcement that allows for precision-tuned torsion. The 106C delivers a stable experience, keeping you planted and engaged in every turn. Uni-Directional Flax improves the skis'' ability to track in variable terrain, making them maneuverable and composed. At a more approachable waist width, and without sacrificing mid-range performance, the 106C are nimble, dynamic and supportive. They are the ultimate one ski quiver everyone should have in their lineup.',749.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Mindbender 115 Ski Boots 2023/24 ',4,'The Mindbender 115 W BOA are the ultimate high level freeride boots for any female skier. Equipped with all-new BOA Fit System and K2''s MultiFit Last, these boots have 100 points of micro adjustability and a last designed to accommodate a variety of foot shapes resulting in dialed in performance and a micro-adjustable precision fit. Outfitted with classic Mindbender construction, a heat moldable Powerlite Shell, FastFit Instep, integrated tech fittings, a Powerlock Spyne boasting 50 degrees range of motion, and the PowerFit Pro Tour BOA liner, the 115 W BOA delivers an uncompromising uphill and downhill experience. The BOA Fit System, provides a performance fit engineered to enhance feel, and responsiveness while reducing pressure points by incrementally modulating the Alpine boot closure with precise micro-adjustments.',799.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Recon 120 BOA Ski Boots 2023/24 ',4,'BOA on ski boots? Yep, you read that right. It''s the biggest advancement in skiing, let alone boot fitting in sixty years. You''ve seen this feature on snowboard boots, bike shoes, and even running shoes, so it''s about time we put our heads together with the minds at BOA Fit System to bring something new to skiing, with a laser focus on performance. Harnessing the power of a BOA Fit System, K2 engineers got to work delivering our most adjustable fit with performance-enhancing features. The Recon 120 BOA boots boast a redesigned lower cuff, with an all-new shell, delivering a tighter toe seal. Say goodbye to all your boot-fitting woes, with the new Recon 120 BOA® . Its redesigned shell delivers a better "wrap," and a more even pressure distribution across the foot.',749.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kemper Snowboard Bindings 2023/24 ',5,'Made for getting the best from your snowboard in the park or on the mountain, the Kemper Freestyle Bindings are the ones used by the Kemper pro team and are universally compatible with all major mounting systems. The straps open wide for easy boot entry while the custom memory gel on both the straps and toe cup ensures a uniform and comfortable fit.',314.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kemper Rampage Snowboard 2023/24 ',2,'The Rampage is designed for running laps in the park and sliding endless rails. Soft and forgiving, the Rampage is built for solid park riding with an infusion of freestyle performance. Our park camber provides snappy pop with a solid edge hold. The Kemper x O''Neill collaboration for this season consists of outerwear, snowboards, kid''s snowboards, bindings, and splitboards utilizing the iconic Rampage graphic.',685.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('LINE Chronic 101 Ski 2023/24',1,'It''s an all-new Chronic, maaan! We''re stoked to introduce the expansion of the Chronic Collection with the all-new Chronic 101. This versatile all-mountain freestyle ski features the same durability superpowers as its little brother down to the beefed-up sidewalls, tips, and core. For those wanting to take advantage of all the mountain has to offer in the morning, followed by afternoon hot laps in the park, the Chronic 101 is here for all-mountain freestyle enjoyment. Become part of the C crew and get after it on the Chronic 101.',699.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('LINE Chronic 94 Ski 2023/24',1,'Designed for all-mountain freestyle enjoyment, the Chronic 94 remains the dopest all-mountain freestyle ski. What''s even doper is the adjustments we''ve made to this flagship ski for the 23/24 season. Complete with Bio-Resin to increase bonding within the core, new Thin Tip Technology to increase tip and tail durability, and Thick-Cut Sidewalls for added edge strength, the Chronic 94 is the beefiest freestyle ski we''ve ever made. Pair these durability improvements with a refined overall shape, and you''ve got a sustainable ski that will feel just as good stepping up to the big jump line as it will ripping early morning groomers.',649.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nordica Enforcer 100 Ski 2023/24',1,'Guided by a commitment to relentless refinement, Nordica has completely reimagined the Enforcer 100. Thanks to a new construction and an upgraded tip design, this best-selling ski offers a more playful feel and even greater versatility—while continuing to deliver its legendary all mountain performance. For a trusted ride that''s especially smooth and stable, it pairs an all new carbon chassis with a new core profile and two sheets of metal. In addition to dampening vibrations and reducing weight, this creates a more forgiving ski that also maximizes stability and response. And to boost confidence in variable conditions, the Enforcer features an early rise tip and slight tail rocker with traditional camber under foot. Armed with a modern design, it allows you to ski how you want—where you want. Smoother and more playful than ever, the new Enforcer 100 redefines what an all mountain ski can do.',849.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Smith Vantage MIPS Helmet',6,'The Vantage was built for the hardcore, demanding the ultimate in everything. Using Aerocore construction that features Koroyd simultaneously maximizes full coverage protection and increased airflow. For the most custom fit, the Vantage offers the Boa 360 fit system with a 360 halo design. Combine all this with the Smith-pioneered AirEvac technology for goggle integration, and the Vantage delivers the perfect blend of technology and style.',319.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('POC Obex MIPS Communication',6,'Featuring an integrated POC Aid Communication Headset, the Obex MIPS Communication makes it easy to stay connected on the mountain. Lightweight and well ventilated, the helmet is ideal for all-day, all-mountain use.Constructed with an EPS liner, PC shell and an ABS top shell, the helmet balances security and durability with comfort and protection.The interior size adjustment system spans the circumference of the head, making it easy to find a secure and comfortable fit without needing to change pads.Sliding vent covers make it easy to adjust ventilation for maximum comfort in all weather conditions, while the addition of integrated vents at the front of the helmet allow air to evacuate from goggles, preventing fogging.',349.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Smith Liberty MIPS Helmet',6,'You bought your season pass for a reason. Now you need a helmet that feels as good on a storm-filled powder day as it does a bluebird groomer session or a backcountry mission. The women''s Smith Liberty helmet brings the added energy absorption of zonal Koroyd® and the advanced angled impact protection of MIPS to let you focus on ripping turns in the alpine and chasing powder stashes in the trees. Its hybrid shell design adds durability without weighing you down, while a plush sweat-wicking liner makes for all-conditions cosiness. And because you love to ski or ride all day, the fit and vents are adjustable on the fly, so you can fine-tune the comfort.',279.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Wildheart Snowboard 2021/22',2,'At first glance, the K2 Wildheart gives the appearance of a one-trick powder pony. But as soon as you get it on the groomers or start riding it through the trees you''ll come to realize it''s an extremely versatile performer that will quickly become a staple in your quiver. The directional Wildheart sticks with a tried-and-true Camber Profile that rails on groomers just as hard as it rips in powder. Our Volume Shift design allows you to use a slightly shorter board than your usual length without sacrificing float in deep snow, and allows you to tip the board over even further while carving without pesky toe or heel drag.',224.95);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Slash Portal Snowboard 2022/23',2,'The Portal is Slash''s all-out powder rocket. Its nose, reminiscent of a snow plough, elevated and oversized for cutting through the white gold like a hot knife through butter. Its tail, beautifully tapered and akin to that of a swallow, allows the rider to steer this magnificent beast through powder as gracefully as you like. Also benefitting from a slight re-tune for 22/23, those with a keen eye for detail will notice a slightly looser ride for this winter thanks to a reduction in wood in all the right places. Equipped with their Float set of inserts, when the snow’‘s extra deep, set back, relax and enjoy dropping pillows, slashing banks and staying afloat with our supreme flotation device.',685.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Kemper Rampage Snowboard 2023/24',2,'The Rampage is designed for running laps in the park and sliding endless rails. Soft and forgiving, the Rampage is built for solid park riding with an infusion of freestyle performance. Our park camber provides snappy pop with a solid edge hold. The Kemper x O''Neill collaboration for this season consists of outerwear, snowboards, kid''s snowboards, bindings, and splitboards utilizing the iconic Rampage graphic.',474.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Head Edge LYT 90 Ski Boot 2022/23',4,'The EDGE LYT 90 are the perfect ski boots for the ambitious intermediate. Hi-Top Tech combines leg and shell into one compact unit. The result: better skiing with less effort. Your valuable energy gets directly transmitted to your ski with the maximum amount of control. Besides Duo Flex supports you. If you apply more pressure, the flex gets stiffer. Equally, the flex is reactive and elastic. Hence your turns have more power than ever.',304.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 B.F.C. 120 GW Ski Boots 2023/24 ',4,'The BFC 120 is for experienced skiers who need a bit more room in their ski boots, without compromising support and responsiveness. With a 103mm last and a performance-oriented 120 flex, these boots are packed with features like our new and improved Cushfit Pro liner, updated Apres Mode, Hands Free Entry, and a new, sleek, fully heat-moldable shell. The BFC 120 focuses on delivering both comfort and an uncompromised downhill performance.',599.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Anthem 105 Heat MV Ski Boots 2022/23',4,'Cold toes are a thing of the past once you step into the women''s-specific Anthem 105 HEAT. Sporting a Bluetooth-controlled Therm-ic heated liner, fully heat-moldable Powerlite shell, a 105 flex rating, and a 100mm last, this boot will have you skiing from bell to bell in warm, toasty bliss.',719.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Smith Squad MAG Goggles',8,'The perfect match for one-of-a-kind pure blue bird days, the gray base lens tint reduces glare and sun rays for optimal vision and performance. From bright and sunny to dark and stormy, everyday on the mountain has its own personality. The Smith Squad MAG goggles include two interchangeable lenses and our easiest lens change system so you always have the right tint for the conditions. Six magnetic contact points and two simple levers let you change lenses anywhere, anytime. The cylindrical lens design offers a wide field of view and our contrast-enhancing, color-boosting ChromaPop technology gives you elevated clarity and detail for alpine runs and tree stashes alike, all with the option of a quick lens change anytime the conditions warrant. Our AirEvac™ helmet integration design helps keep them fog free through it all.',279.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Smith I/O MAG XL Goggles ',8,'You can only scope your line if you can see where you''re going. Putting on the Smith I/O MAG XL goggles is like flipping the switch from regular to extra-widescreen. Our ChromaPop lens tech boosts color and contrast, so you get the clearest picture of the terrain ahead. Our highest level of anti-fog treatment and air flow keep the view sharp. Whether the day dawns clear or stormy, lens swaps are a snap thanks to our quick-swap MAG lens system. Because no two faces are the same, the XL model expands on the standard size for those looking for the largest possible lens.',319.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Smith Squad XL Goggles ',8,'Bigger is better when it comes to your field of view on the mountain. The Smith Squad XL goggles feature our largest cylindrical lens for full-width vision in any terrain. The view is backed up by sharp optics and our highest level of anti-fog tech. ChromaPop lenses heighten contrast and color, so whether you are ripping high-speed arcs or sighting your landing, every terrain feature comes through loud and clear.',179.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Arc''teryx Gothic Glove',7,'Lightweight, touch screen compatible merino wool glove designed for use as a standalone or liner. Made with soft, warm merino wool, and with a next-to-skin fit, the Gothic Glove is an excellent insulating liner but also functions well on its own. Worn under a shell, it provides warmth, naturally resists odors and insulates even if wet. Light and easy to pack or stow in a pocket, it’s also great for cold weather trail runs, spring cross-country ski tours or cool evenings. Sensors on the thumb and forefinger enable use of smartphones, tablets, and other touch screen digital tools.',49.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Carmel Windstopper Mitt',7,'The Armada Carmel Windstopper Mitt, equipped with a polyester Shell and Gore Windstopper lining, keeps your hands feeling warm and protected. Unique prints keep things looking fresh. Palm prints add extra grip so your hand never slides off those grabs again.',89.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Arc''teryx Mantis 30 Backpack ',7,'Comfortable, streamlined, highly versatile 30L pack made with recycled materials. Created to give you the freedom to roam – and made with a clean design and recycled materials – the largest Mantis'' capacity, organization, durability, and balanced carry make it a go-to however and wherever you want to explore. Its wide top opening allows easy access to the large main compartment, and multiple pockets -inside and out – organize gear. The padded back, frame sheet, and aluminum stay combine for a comfortable carry, and a sleeve in the main compartment holds your hydration reservoir or laptop.',199.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Corwin 2L Insulated Pant ',7,'The Corwin Insulated Pant pairs perfectly with the warmest jackets to create an ultra-toasty system that feels balmy even when it''s downright frigid. 40g of 90% Recycled Polyfill throughout the pants provides ample warmth without feeling bulky or heavy, and the 10K/10K Oxford Weave fabric and CORDURA reinforced cuffs stand up to endless days of cold-weather punishment.',289.95);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 18);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 10);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 22);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.35);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 25);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 30);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 40);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 97);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 31);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'AB', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'BC', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'NU', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/P1.png' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/P2.png' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/P3.png' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/P4.png' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/P5.png' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/P6.png' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/P7.png' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/P8.png' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/P9.png' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/P10.png' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/P11.png' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/P12.png' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/P13.png' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'img/P14.png' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'img/P15.png' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'img/P16.png' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'img/P17.png' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'img/P18.png' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'img/P19.png' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'img/P20.png' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'img/P21.png' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'img/P22.png' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'img/P23.png' WHERE ProductId = 23;
UPDATE Product SET productImageURL = 'img/P24.png' WHERE ProductId = 24;
UPDATE Product SET productImageURL = 'img/P25.png' WHERE ProductId = 25;
UPDATE Product SET productImageURL = 'img/P26.png' WHERE ProductId = 26;
UPDATE Product SET productImageURL = 'img/P27.png' WHERE ProductId = 27;
UPDATE Product SET productImageURL = 'img/P28.png' WHERE ProductId = 28;
UPDATE Product SET productImageURL = 'img/P29.png' WHERE ProductId = 29;
UPDATE Product SET productImageURL = 'img/P30.png' WHERE ProductId = 30;
UPDATE Product SET productImageURL = 'img/P31.png' WHERE ProductId = 31;
UPDATE Product SET productImageURL = 'img/P32.png' WHERE ProductId = 32;
UPDATE Product SET productImageURL = 'img/P33.png' WHERE ProductId = 33;
UPDATE Product SET productImageURL = 'img/P34.png' WHERE ProductId = 34;

-- Loads image data for product 1
UPDATE Product SET productImage = 0xffd8ffe000104a46494600010100000100010000ffdb00840009060712131215131313151515171817171515171717181718171717161717171517181d2820181a251d151721312125292b2e2e2e171f3338332d37282d2e2b010a0a0a0e0d0e1a10101b2d251f252b2d2d2d2d2f2d2d2b2e2d2d2d2d2d2d2b2b2b2d2d2d2d2d2d2d2d2d2b2d2d2d2d2d2d2d2b2d2d2b2d2d2d2d2b2d2d2d2d2bffc000110800c2010303012200021101031101ffc4001b00000105010100000000000000000000000200010304050607ffc4004010000103020304080403060505010000000100021103210431410512516106132232718191a152b1c1d14272f0236282b2e1f11415163392345373a2d207ffc4001a010002030101000000000000000000000000010203040506ffc4002a1100020201040201020603000000000000000102031104122131134151226105323342819171a1d1ffda000c03010002110311003f00810945099672c1932772125002052053129a54931325053ca865105222c9779284011a004d6a2081a51b5458c508d81353289ed82900aa051c2900285c80037522d44122ef34000022490ca603c249d104c420110285384d08918a7c3e6951a5212a79a9262659c3b2e14cf10e55f0cf833c1155a8499534f822d724f56a12eb9952e02a43c5e1520f44c29e79135c1d1d7da2d00c1d173a209be5aa17bcdd0029ca4d8a3051e8b7fe5d40de5c3900928baf7264657c0625f2623901444262164348084a94040e40029a5102990032209d385210e2522534a62119104d72980909f058275436b3466e390fbad5389650ec531d6b8916b0bc6bc05d5165f1816d74ca7d1530db3ea11bc61adf89e607dd3e25f4186ef351c74a605f8ab389a61c01acf33f0830df08cdc2fe73926c2f533fb32db7080272b939e6b14f5537d1b21a682ef91a9542476686efe63bd7e0414f189c86e82720d601ef0a7a55dc1df860697de20117008cb2cb884e71e2e0068741dd1de3adcb8e56d20acee727db2f508ae910d2a55d99d519010e8e7e49ea75a40100ceb00811c654b5a997192f1efeb68bca82a53b897bbcb7f3fd14b731e106cc2cdcd169033dd76efb44a831583a40cf6d91f10de6f8348893e28e1e1c06fc8cc4878fefe8ac56c73c01bc01191b7cc8b82ad85f647a6572a612f4673f67be039b0f69d5877bd40baac02dba3baf76f37b264f227c084d8ca327f6ad2e11fee37be2fada1d96ab657abf52465b34b8fca63052efa92be17746f021ec360f194f070fc2791f295000b6c5a6b28c6d35c309b54e48c3d46113829a22107a3eb142114a604a5c90aa545296f262c066a14c2a15184903c121ae5251c24802b3820705631748b5c47a1e21562b3968dbc9248094004f429a5384c0269489421130204257f676083e5ce3bac1727531986ad0ff004e5434595ac18e20677bce43c954dab8d635a29333223b3a007e64fdf82cf7dbb385d97d156f7c916d1c639ffb2a32da7066d123f36716f9a88bbab616082e393a67cc9c8468a6ea8b69ef0992274304f982564e198e7104b5c3760913a9e3a0cb52b9f9cf674e292584495a9bded92fb44191322d9a9b054ea1225dba72ee3a47980042d2c1b3b40b298ddce6f1391e4606aa7c63e9b7bed630c82489bce53ce74e1ecb77a0c87b3db6d60483bc1b79e2065171e4ae3767071de1022c4c6995a341926d881952a38b5d2441eaf2de19183c6345d260a8d324be982d70b39a6639b7faf252854e453659b4c3c5d0a74dae710406893264db809850d16b9c3b2dbc4c13bc1be90ba4da5870e02dfba7cf8ac9af83751786b01707093a584ff4f644ea71646366515e9e01ff008a0e440fb82e3af0093b040080d8813970f204e47256aa55d44f0e1e055bc2f6d84c078c8b4663cb8e5c128c53781b935c9ce330fbe09197e133711e5636362ac61aad4162779bc1c3b5c3316239e775b988c0c8902639c387000f0e46cb22ad18710eccf762774deee6ead3c5a4dbc2e9ca0e23535221ad44365d4ee0f79a6208e046a3e5f2c9c5e161bd632773223561e0788e07cb99d9a4371c73beba1ca654551c29b8bb7658eecb9a79e9cc1faab68bdc1fd8aada94d7dcc00e468f69617aa7c032d3da63b8b4fd4411e4ab872eb2e5651cd7c13b427365abd1a661cb9c710e21a0580d4f0b2cec539a5c7727764c4e71a4a622294c9a532603929d327400fe899249033471b87de1cd62d46c2eb37010b3369e07f1058e322f68c17041baa5a8a17156111142e09262800a538728a5269d067f54643075984c6b99856efb8c09735b39366240f195caf586a5473ac0e423d8dec4fd9751d2466e536b1a090d6b596b7e1179d32f75cd60599836bda07b831132335cdb25993674e88e22586517b1901ce2e233d018390c869a6a15de8e619d58c3d90d68398209d01390e197050e2311bb1de25d0019b0b92275d0e7c174fd1d637fc3cb4f7886e64de6f79e0156b92737b515712008008ddc841222384e79045b3594b7e6a0749821f32d90008205c653395d686130fbce27741821ac69c85892e227412a96d3a2ded410d2d7006206f7181e50849c7ea2bca7c17ea5263b72a53a448610eeb058c0cc3466e90b7e83a9bfb6d37e563e63eeb2b67baad36f77ac66620dc7f44558d1799dddd7f983ff00a9f9ad30928acffaff008679a72e0d6ad7b037e06d2a1608733902dcb5b47c8ac815cb4c6e92393c3867ab5c787cd5da18b9ce67313636e13984fca9b23e3690d536782fa8ebc82204d888923ce55aa7866b5c1ec101d9e9122c7d6d1cd1e1de0971d0c7b483f2f643b3c8ea5a45c588e1136214e318e7245c9e09ead306fa8f4595b4b05be3b3232730e50e19784e47911c16bd7f1cc11ed20a8314dec9e3263d0a95914c5093472ae3bc32bc4e519662fc0a82b337816927b423d7ed3eea52e9ab52c1ad0f311799874dbf31b2a98a96c1b4099893a0cad9ae7f4cdc86c5c54c396df7e8ba660ddae8def9b4f915841cba7d9b481a8ea768a8c223f337978caaace88e2357521fc4effe57574b2cc3fc1cdd4c52998bbe9b78ad5c5747decb3ab510786f3e7d03166d6c3b870238b4cfa8cc7985a37c738c95f8e7b7761e3e45bf29c28778a30e0548812a484046d400c4734924900746eadaeba840faa3f5a2a95abc19555f5fd161c1a7256da98783bc32d56538ad7ab5a6c6eb36b88cb256222420a671942e2a373900138ad6e8fece0f3d6bfb8d36fde70b8f2199f4e2b270741d56a369b737189e03324f2024f92e836ce25ac6b6853b340f6e7cc9b955d9628acb2ea6a764b08bfd209783130e02fa5b4e6572983c06f3b78d422f103ef39db86abb0ac77a935cdc9a01dd1ee39d9735470ce6b9e445c92d8ca2d9ac1278c9babeb058c6d26f560c581793e7bf3ee5751d14aa0e19961675fd482572b8332d23b4e937de376cc67c06775b5d13a818f7d17080eb81a4e8678c09f54ab78781dab313a3c19dd241fc2e9f2bb0e5c883e68f13b39af0e02ce0ede06d704cc4f099093c1b9c8880ff004ef787db927a460c130446e3b87ee93a8fd705a163a66479ed1252a25a268d86ac3c78724ffe3db954a65ba5c023df9296013f03f88fc5e1398f7445ef6882d0fe6207a82ac4b1d15e73d946abd93614f94b5cd39fcfeca37b41c9a1b7d1d23fe2467e10b40e2003fedb873dd1f42a17552743c04d3989e3055728af926a4c93015a0386a04c7aab54de37401e1e62e7e442cf2f026c41b5c4e40c9cee33f05353ab27764766c799f0e6483fdd4e12c2c109473c97aa3a4f2fd4fb7cd438f814cc9ce7d48223dfd91d3640ed79cae776fed235269d276e98ef40313f88f0b65e654ec96d596284774b08cf6bc75936ed4badc80032b64df928710db4dccdf41602c07a7aa6c1002c41305ad07424477634cd59acd61300e86c070811e1f4580dbd05801188a42d66367e600e42eb4aa6dda533bcb330a775b5ab910435c01220cc6eb47bfb2c4d8f4e9bea6ed4923400c4f1be6ba5a6942b87d4fb7c186fae7649b8ae9726e6d1c461eb779c41ca458f9e853e0f64527b619586fe9222791e4b0315b3fab7b81702013ba41bb8686d92a987c4b9ae8056af05527968ae3aabe11c465c7c136d4c23a9542c708d40e4787119fa2aa1cb536fe33ac1449ef0619f09b7d5642b1c76f051bb7724eda8a6639550883a1202df589283ac49005818890a075454d952119a8b3e0bc99cf50bdc837942f72008eb3a0aacf7a3a855771506491d2746a90653a95ceb2c6f8082f3fca3c8acfa958b9c5c752b6768d3eab094a9e44b5b3e2eedbbdc9585bb0b9fa997d583b1a0af11ddf274fd1fc436a30d139c5ffa2ab8ca4699702498bdad6ca40e2b2f058a753ee98b827f84380fe62ba37eee25a0e5506a0c65711c4282fae39f6885b0f14feccc5158364644def6063cec7b4ae616ab5c2c408bc4c96f872b1f555b1d4099105cd00f1e36cb239eba2a143b0fd18d11af6a6c0cce9ce38286dc8fb3bdd97b5c1863cc3c0ecbaf04703ecb59a018b01c04db8f60f0e4b84a6f6bda378820e47e60e8afe1f6bd7a400de0f65bbc2f1caead85d8e24513a73cc4eb1d49d9778703a787e8a885522d2e6f983e80feaca860fa474c821c0b08cc1ed666d91365a14b6c5022ee6f9dbd8dc2b94a0fa91438cd768858635277af918190f8a07878a166f97d9ae8bde7c22d078f1564edbc3de2a34c66044aaa3a4d4cc86b5c633e1e5c7c927b177205bdfed2c8a553383e1235cf9856308d8264446a74fd5d61bb6fd53986b26235e1ef9a7c1edb7583e5dbd620c0239f8792236569f0375cf1c936dbda0e782ca6edd1f17a139e7c394ae7dcced8bb9e6099b16924cdcea401a7aab3b4f676f986bdc1a2f02493af8932ac50a45ad3eb71a0fddb1e1654ca4e4f2cba2945704987c2112e264982358d21be5f5f221858b364971f41611c6f727c426eb88c8c9d380e190b7f4572ae25b46997bbbd98be4389fa7aab69a5d92c229badd88abb65f4c34517491de700624e809e0173f571ac65a9b1ade79bbd4dd65e2b683ea38baf73ecaa3dff001397465669e0d7595fd99614ea669a59c3fe116eb62c9282958c9f45a3d1a146a87b0b417b839ad71d1c47648e17216602ae858a4b72299d6e12dac37d493273fa0c9208520148892028c15116eaa40800924329d0050de441f0a2253172a0b895ce5139c8494ed51632071286953de7b5a7f139adf5207d549511e01e3afa3ff969ff003b5564cea7a58e97b478fd02c1785b7d281fb56f81f9858cf5ccd47ea33bda4fd288cd6ab185c51611750b4a072aab9b83ca2dbab56476b3a173c568bee919c6be2387350e3b67968820bc1d40b0d7dd6261f1645a7ee16ce136ac677e63ea16ef12b1660722529d4f12e8ab42ab298001dd2731909f036b2238d13f86fc0c65e02eaee30d3ad121b9e793b4b0b72d164d6d90f811ba0cc492440b7a67ecb3ba9afcc5d1b2322ce1b6890e1fb3b6a64127990214e6b02edede20644469c3358f5767398e880e906e4bb747a0cadcd057c3b1907b6fb7e1eedec731296c4c9651b60b7bc37c1e3603c7385252c68020344dccddc2fa9bc42c5a5836541d8754266f940cfe289c94986d9750c82f96cde5c62e32b4f24b620ca2f62319902e17f88c699868c94076a916a6d2ee2e7022f7cb502dc546dd8ae719351807c2d378390026d395eeb630bb3b72ed69ca0979802dc0c79e6a7187c2c9094e29726450af52ee7cdf29740beb7e6b7b06096c76ef39120dff002e43993c156028b092e21eed37411e45c4c90956da648810d6f01f53aad95e8e52e65c231dbab8f51e59ac710da77cddc3f0b7ee7d972fd22da85e77267528b198cdd1cf458551f264ab6e9c6b8f8e1fc869a994e5e49ff00f5aee2a07b895216c942ca25634d23a4d366af44ea16d604685a7d0ab5b4a9eed5aadd1af781e01c427e8b617f6a7cbe6a4dbff00f515a3feed4fe62ba3a696e81c7d6476da536b914a009c15a0cc1929da53045bb6400e0a4884248032814ea0de21482afaaa196824a41e81c5328b2486aae51d2abbae6bbe121de841fa2271503d41a248eefa56cbb5c38fcc4fd160542b74bbafc131f990d00fe6658fac1f558442e6ea562793b7a29e6bc7c08144e0144d45a2cc6d667d57c38c2968e27c8a82be654056d870b28c3624de19b0dc47f70a7a3b45edeebcf82c36e211f5fc56a8dcfd986cd2aed1d0b76ebc66da6ee658d27d62546fdab4cf7a88e1de78f401d01609ac398f3426b733ecac5e37e8a1d762e99bf4f6b5219528fe37fdd48ddb6d021b45919dc137e375cdf5c7894bade654978be08b85afd9d1bf6dd493bbbade6d004fb4aab531ee7779e4ac61514b4cb8e52a5e68c7a12d2ca5d9a6311e4899589cac38fd94143067377a2b6165b756df1136d5a38c799015180acfaadbad17955eab25644f9e4d8d71c15688bab61aa3a6c82a52ab9bcb2d8708e8fa1586dea93cc7b5feab071988dfa8f7fc4f73bfe4e27eaba4c13bfc3e12a5436218437f3d4ecb7d0ba7c9720d6aece963b6b593cf6ae7bed6d1641441441c8c15a0ce4928828c292500179a49049006197252865254170529129a5324030285e114a62a233a3e84e37bf8777e2edb3c40870f400f91418ec31a750b74cc782c0a155cc735ed30e6904788fa2eeb114db8aa0dab4fbdc350e1de69fd7059b5156e8f06dd25fe39e1f4ce6cb53808e38a60172d9dd4ca58ba5aaa2f6adaab4ed0b3aad285a6a9fa335b0f65173547242b658a375357e4a089ae9d148da52898c5629a4e4d0d462fb206e1d58661478ab14d92acb28f255bb1935544af4b08382b8c681904429a63655b937d9351c7422531281c84ca109a1dc54728b76513694a9369028b63530aeecbc11a95008b0b9fa0fd7051b69e400926c02eb70149983c3bab54beee9f1bcf75a3f590254b4f5bb6655abb9555fdcc1e9be3377abc2b736c54abf99c218df26927f8c2e777ac831159f56a3ea5432e7b8b9c799e1cbec89abb6d638479d5cf24cc722de51351b4a064f4dc8b3cd421ca4694c44c1e921de49006194912072ce5c249304e80114251142424312d1d81b6ce16af6a4d27daa0e1c1e0711ee166a6a8d9084077fb676607815a890e04036c9c34239ac117543a33d257614f57525d449b8ccb2756f2e23f47afc6ecc65768ad41c0ef09b64efb158b53a5cfd513a5a3d6e3e89ff66096916220f050d7a1370a6a8d2d3bae0411c734d75cecb4cebf68cca94d40e6ad77d20e55df852af85a532acce014d48299d8609851566f457e32c510ac0a838aaada6a56b154d96244a5e9a50c24a24852993ca36529cd1bb01b4168953b445867a22a34cb8eeb1b27969e3c174db3363b28b4d6ace0204971c87829d554ed7c74557ea214c79efe00d85b20301ad5886c02493935a3392b95e946dfff0015500648a2cb53194f179e67d879a3e95749ce23f674c16d106c357c7e27f2e03cf3cb070d497729aa354708f3975d2ba5b99728b2c93e9f0461180a44085a8823737828820091aa4de510288d44c0983d3a86524019ad4d09a53ef2ce5a306a49a524c424e534262818884c13c2509606435e8cdd49b1b6e56c23e699969ef30f74f3e479fcd48d0abe270d370a5197a626bda3d0f676d9c1e386ebbb157e13670fca750a3c6ec1ab4eecedb7967e9af92f2ea8d2d3c1741b1ba6d89a10d27ad670767e4efbcaaedd242ce4be8d6d9570baf8374d8c1041e762942d1c1f4c7038800566f56efde16f277f55a4dd8986aa37a8d617e0e047bfdd73a7a0b23f9793a95fe2754bf370736ea72a334174553a3158775ed3e208f94aaefd83881f85a7c0fdc2a5d1747d3342d4d12fdc8c5148a7eacad4ff0027c4fc03fe4113361e24e8d1e27ec12f15bf0c7e7a57ee5fd993d514ba91a95bf4ba3154f79e07809f9ab3fe9fc3d3bd57cc67bce81e8202b63a5b65f62a9eba88fbc9ccd312618d2e3c009fecb6301d1eab52efec8e033f3390f752627a5581a02298eb08d182deb92e6b6b74d3115a5ac22933837bde6efb42d956812e6473eefc4e4f882c1d863369e1302dddb39ff036e678b8e9e2570db6f6f56c53a6a1868eeb07747dcf359209cf3474db2ba318460b08e5ca729bcb0a9b64abcca7082953853649390241351a109c94861212d94e9c20012147aa9f750bda98885cd3c524e4a48033ca4853aa0b441c9d0b4a2940049cb50846d4003098b511174481834c2321201109480af570a1cb3abe01c320b6daa7a4d09ef710da99c9ba991984546a39865ae734f16923e4bb96ecba7500040e03fb8c954da1d136c9eadd039dc5f9d8fcd0b550ce1f00e89768c7c2f49b194fbb5dde707e62569d2e9ee35b9b98ef169fa159f8be8e576680e963f78bdc2a55304f6e6d23c95f19c65d32a7192ed1d2b7ff00d0317c29fa1fba8eaf4f31a7234c7f09fbae70523c0a3144f04f08469623a558d7e759c393401f459955ef7997b9ce3fbc49f9a91b48a91b4502206b548da4ad52a0a765208dc3c15a9502add3a402209017516f234891396a008c35218402445d0ca70810e4a26041bc89bc9300c14ce4e4a1940025a9d21e09200c9482492a0b062914c9260185204924c05aa67a74900208986e924931929faa918924a0c9234305de6f88f9aea317de3fad124961d4768d3574455402c74df337e30b9ada406f1f3f9a4929697b15fd18ef49c12497511898d4c5d4ff0064e92188433fd7346c4c924026e6892490046dd3f5a2b0c4924000754c7f5e89249811d336533734924c448d409248181299249007ffd9 WHERE ProductId = 1;