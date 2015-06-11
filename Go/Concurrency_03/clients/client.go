package clients

import (
	"shops"
	"config"
	"time"
	"collections"
)

func Client(shopsAvailable [config.NumberOfShops]*shops.Shop) {
	counter := 0
	productCounter := 0
	size := len(shopsAvailable)
	tempProduct := new(collections.TaskToDo)

	for {
		if counter == size  {
			counter = 0
		}
		if productCounter == 2000 {
			productCounter = 0
		}
		if productCounter % 2 == 0 {

			shopsAvailable[counter].SellSumProduct(tempProduct)
		}
		if productCounter % 3 == 0{
			shopsAvailable[counter].SellMinusProduct(tempProduct)
		}
		if productCounter % 5 == 0{
			shopsAvailable[counter].SellMultipleProduct(tempProduct)
		}
		counter++
		productCounter++
		time.Sleep(time.Second * time.Duration(config.ClientBreak))
	}
}

