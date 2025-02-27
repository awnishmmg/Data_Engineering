### App Script
```
var sheet = SpreadsheetApp.openById("1FnbH5mq8YVqHLYuyZ-etTEUBjLZgD9G82GZUdubQFgw").getSheetByName("Sheet1");

// 📌 CREATE Operation (Insert Row)
function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);
    
     //Call function to insert a column and copy formatting
     insertColumnAndCopyFormat(data);
    
     // Insert new data into the sheet
     // sheet.appendRow([data.id, data.kpi_name, data.count]);

    return ContentService.createTextOutput(
      JSON.stringify({ status: "success", message: "Data inserted & column updated" })
    ).setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    return ContentService.createTextOutput(
      JSON.stringify({ status: "error", message: err.message })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function insertColumnAndCopyFormat(data) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var colY = sheet.getLastColumn();
  
  // Insert a new column to the right of column Y (i.e., column Z)
  sheet.insertColumnAfter(colY);

  // Copy formatting from column Y to column Z
  var lastRow = sheet.getLastRow();
  var rangeY = sheet.getRange(1, colY, lastRow, 1);
  var rangeZ = sheet.getRange(1, colY + 1, lastRow, 1);
  rangeY.copyTo(rangeZ, { formatOnly: true });

  // Copy data validation (dropdowns, etc.)
  var rules = rangeY.getDataValidations();
  rangeZ.setDataValidations(rules);

  // Set a header for the new column
  sheet.getRange(1, colY + 1).setValue(data["date_title"]);

  // Fill in sample data (Replace with actual PHP data if needed)
  for (var i = 2; i <= lastRow; i++) {
    sheet.getRange(i, colY + 1).setValue(data["result"][i-2].data_count); // Example values
  }
  
  return "Column Inserted & Formatting Copied!";
}

```
