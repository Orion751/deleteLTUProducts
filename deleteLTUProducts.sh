#!/bin/bash

# Usage: creds newScript dir

: '

Pseudocode

    tag1Key = source
    tag1Value = bestbuy
    tag2Key = producttype

For every dir

    tag2Value = dir

    for every subdir in dir

    make new visual with name from subdir

    for every image in subdir

        add the image to the new visual

'

creds="$1"

source=~/Documents/Code/pdf2png/src/bestbuy/Cell\ Phones

for dir in "$source"/*; do

    visName=`basename "$dir"`

    sleep .2

    isAccessory=`curl "https://api.bestbuy.com/v1/products(sku=$visName&categoryPath.name=Cell%20Phone%20Accessories*)?apiKey=j8zn4cz86rrm32a7h8bubv6g&sort=sku.asc&show=sku&callback=angular.callbacks._x&format=json" | grep '"total"' | head -1 | grep 1 | wc -l`

    if [ "$isAccessory" = 1 ]; then
        curl -u "$creds" "https://cloud.ltutech.com/api/v1/projects/491/visuals/$visName" -X DELETE
        rm -r "$dir"

    fi


    : '
    visID=`curl -i -X POST -u "$creds" https://cloud.ltutech.com/api/v1/projects/491/visuals/ -F title="$visName" -F name="$visName" -F metadata-0-key="$tag1Key" -F metadata-0-value="$tag1Value" | tail -1 | python -mjson.tool | grep \"id\" | head -1 | grep -oP '\d*'`

    for image in "$dir"/*; do

        curl -i -X POST -u "$creds" https://cloud.ltutech.com/api/v1/projects/visuals/"$visID"/images/ -F image=@"$image"

    done
    '

done

