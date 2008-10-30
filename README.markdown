Flexi Rate Shipping
===================
Flexi Rate Shipping is an extension to Spree (a complete open source commerce solution for Ruby on Rails) that uses predefined values to calculate shipping. This extension is designed to be used when a traditional UPS / FedEx API approach in unavailable or unsuitable. 

When installed, a new "Flexi Shipping Rates" link is added to the Configuration area in the Spree administration interface. Here you can define as many different rates as required, and link them to the relevant Shipping Categories and Zones.  

Each FlexiShippingRate contains the following values:

1. **Shipping Category:** Each FlexiShippingRate is associated with a _Shipping Category_, which is used to link products to particular rates. Several FlexiShippingRates can be associated with the same _Shipping Category_ provided that each one uses a different _Zone_.

2. **Zone:** Relates the FlexiShippingRate with a particular _Zone_ so that you can specify different prices for the same _Shipping Category_ by zone.

3. **First Item Price:** This is the amount added to the shipping total for the first item in the order that uses a particular FlexiShippingRate.

4. **Additional Item Price:** Is the amount added to the shipping total for each additional item (after the first item) in the order.

5. **Max. Items:** Is the maximum number of items that can be grouped in a single FlexiShippingRate, the first item that exceeds this value will be charged the _First Item Price_ and the each subsequent item will be charged at the _Additional Item Price_ until the value is reached again, and cycle restarts.


Examples
========
The sample data contained with this extension shows how to configure Spree to support multiple FlexiShippingRates broken down by three different _Shipping Categories_ and two _Zones_.

       Shipping Category             Zone               First Item Price        Additional Item Price         Max. Items
       -----------------------------------------------------------------------------------------------------------------
       Default Shipping              EU_VAT             $ 10.00                 $  2.00                       5
       Small Item Shipping           EU_VAT             $  2.00                 $  0.50                       10
       Large Item Shipping           EU_VAT             $ 25.00                                               1
      
       Default Shipping              North America      $ 40.00                 $ 10.00                       5
       Small Item Shipping           North America      $  6.00                 $  1.50                       10
       Large Item Shipping           North America      $ 75.00                                               1


## Example 1

Cart Contents:

       Product                       Quantity       Shipping Category
       ----------------------------------------------------------------
       Apache Baseball Jersey        1              Default Shipping

The total shipping amount would be:

**EU_VAT Coutries:**  $ 10.00  or  **North America:**    $ 40.00

## Example 2

Cart Contents:

       Product                       Quantity       Shipping Category
       ----------------------------------------------------------------
       Apache Baseball Jersey        6              Default Shipping

The total shipping amount would be:

**EU_VAT Coutries:**  $  28.00  or  **North America:**    $ 120.00


## Example 3

Cart Contents:

       Product                       Quantity       Shipping Category
       ---------------------------------------------------------------- 
       Apache Baseball Jersey        6              Default Shipping
       Ruby on Rails Mug             2              Large Item Shipping

The total shipping amount would be:

**EU_VAT Coutries:**  $  78.00  or  **North America:**    $ 270.00

Quick Start
===========
1. Install extension:

    `script/extension install git://github.com/BDQ/spree-flexi-rate-shipping.git `

2. Migrate the database (or bootstrap if you want the sample data for testing)

    `rake db:migrate`

3. Log in to the Admin interface and associate Products with Shipping Categories.
