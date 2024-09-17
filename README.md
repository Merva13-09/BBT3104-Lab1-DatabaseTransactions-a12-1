[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/r-tQZu0l)
# BBT3104-Lab1of6-DatabaseTransactions


| **Key**                                                               | Value                                                                                                                                                                              |
|---------------|---------------------------------------------------------|
| **Group Name**                                                               | ? |
| **Semester Duration**                                                 | 19<sup>th</sup> August - 25<sup>th</sup> November 2024                                                                                                                       |

## Flowchart

![flowchart](flowchart.png)
## Pseudocode

BEGIN
  START TRANSACTION;

  SET @orderNumber = (SELECT MAX(orderNumber) FROM orders);

  // Assuming a loop for each product
  FOR EACH product IN products:
    SAVEPOINT before_product_1;

    // Update order details for the product
    UPDATE order_details
    SET quantityOrdered = quantityOrdered + 1,
        priceEach = (SELECT priceEach FROM products WHERE productCode = product.productCode)
    WHERE orderNumber = @orderNumber AND productCode = product.productCode;

    SAVEPOINT before_product_2;

    // Update product inventory
    UPDATE products
    SET quantityInStock = quantityInStock - 1
    WHERE productCode = product.productCode;

    // Check if quantityInStock is less than reorder level
    IF quantityInStock < reorderLevel:
      // Trigger reorder process (e.g., place an order with a supplier)
      TRIGGER_REORDER(product.productCode);

    // Commit changes for the current product
    COMMIT;

    // Handle exceptions or errors
    CATCH (exception):
      ROLLBACK TO SAVEPOINT before_product_2;
      // Log error or take corrective action
    END CATCH;

  END FOR;

  // Commit the overall transaction
  COMMIT;

  STOP;
END
## Support for the Sales Departments' Report
