# Trail [PG5601 Exam]
Trail is an app developed as my exam in iOS programming for the autumn semester of 2021. The app lists 100 people randomly generated from the [Random user API](https://randomuser.me), and lets the user see and edit details about each contact. The app also shows every user's location with a custom annotation pin on a map, and it is also possible to change the seed to generate 100 new contacts, deleting the already existing contacts if they have not been edited. Contacts are saved in Core Data, and their information is persisted and accessible even when the app is offline. 

> Project is attached as .zip

## EXCLUDED FUNCTIONALITY
- Tests
- Persisted seed
- Cached images

## KNOWN BUGS
- Images does not load until list view is scrolled
- Detail view does not update after editing after child view is popped, but new data is displayed if contact is tapped from list view again. 
### ABOUT BIRTHDAYS
The logic checks if a contact's birthday lands in the same week as the current week of the user's calendar. Same date does not always mean same week. e.g. November 20th 2021 lands in week 46 and November 20th 1967 lands in week 47 and therefore, the birthday rain will not appear. It's suboptimal, but it does what the task asks for; to check if the contact's birthday is in the current week. 

## SOURCES
### API
https://www.youtube.com/watch?v=V2IfBdxjWs4&t=1377s

### EXTENSIONS
https://newbedev.com/is-a-date-in-same-week-month-year-of-another-date-in-swift
https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

### CONTACT LIST
https://stackoverflow.com/questions/27651507/passing-data-between-tab-viewed-controllers-in-swift

### CONTACT DETAIL 
https://stackoverflow.com/questions/25511945/swift-alert-view-with-ok-and-cancel-which-button-tapped

### EDIT CONTACT
https://developer.apple.com/forums/thread/101483
https://stackoverflow.com/questions/25232009/calculate-age-from-birth-date-using-nsdatecomponents-in-swift

### MAP
https://www.youtube.com/watch?v=DHpL8yz6ot0&t=619s
https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift

### SETTINGS
https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
