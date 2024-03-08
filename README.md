#

https://drive.google.com/file/d/1NgZmzMZGrK47qFUSzwIWPgxD5hXmx899/view?usp=sharing

### questions for matt
- are comments per cut
- if so how to display
- confused
- also, how to display weight station ideally

### Found in Heavner Meats, beef
### show preview of comments and click to show below
## weight station
- select the order
- sex choices for each animal (cow or pig) different
- age for cow over 30/under 30
- ear tag  ? number from customer
- weight automatic
- function to re-weight
- organs accepted//not wanted//rejected
- list of organs, imagining two columns 
- accepted || rejects || not requested
- or all accepted or all rejected
- list of check boxes
- blank ones they didnt want anything
- big boxes of rejected/accepted;
- comments++


## Debugging 
- ~~reverse from order to select animals
- ~~fix select recipient on order review
- ~~load cutsheet crud on finish/update order instead of customer search
- ~~duplicate  set check boxes
- separate animals from cutsheet from pending  in Customer.animals.amount/

## Latest
- track down remaining count
- cutsheetsByEvent(sheets)
- on customer grab centralize:
	- animals
	- remaining
	- profile

- New CUSTOMERSEARCH
get YearWeek, see: A_YWeek

main sheet  - line 143, is an array and needs to iterate one more time

test event for future or past event 
if future, set as valid event

searchCustomers.ahk line 240

``` 

        for index, event in custEvents

        {

            yearWeek := event['year'] event['week']

            customersWithEvents.Set(event["customer"], customers[event["customer"]])

        }

    }
```

## Wizard
- ~~display set options for already finalized OrderedMap - when clicking an already filled Cut~
- ~~comment button and field on wizard, replace restart
- ~~load  saved order from event~~
- ~~button include order/finalize~~
- ~~large searchcustomer text header~~
- 'step 3. check mark sets value'
- 'step 4. order review to see set values'
## Order Review
- display producer on Order Review
- save for later
- address && contact in order review
- comparison tab for old sheets [[importing cutsheet]]
	- supersede built order with historic
	- send compared fields to current order

## Animal Count page
- drop down menu on cut ins needs to text field for pigs
- .5 incrementer for pigs
-  quarter cow drop down for cows
## customer profile
- cut sheets historical
- slaughter dates
- customers - pull from cutting instruction recipients  
- history and save old cut sheets on customer profile at sql level
- be able to select 

## Submitting for Order
- Customer.animals.remaining = cutsheet_remaining = event
- Cutsheet.animals.total 
- Customer.event = Map()
- Customer.Producer
- Customer.Recipient
- OrderMap

ngrok

https://gist.github.com/YamiOdymel/d0337a6be3b2f1297c9eeab6c196fcb7

Set and send an `ngrok-skip-browser-warning` request header with any value.

sudo apt-get update
sudo apt-get install unzip wget
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ./ngrok /usr/bin/ngrok
ngrok http 8080
![ezgif-2-01d0d929cd](https://github.com/samfisherirl/Heavner_Meats/assets/98753696/647e5b7b-9fbb-4e2e-9b30-f1017e7c0bc2)
