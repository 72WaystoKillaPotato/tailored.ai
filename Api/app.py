from flask import Flask, jsonify, request
import random
import numpy as np
import os
from fashionpedia.fp import Fashionpedia

# GLOBAL VARS
anno_file = "annotations.json"
img_root = "images"
fp = Fashionpedia(anno_file)
categories = {
    "Tops": ["shirt", "blouse", "top", "t-shirt", "sweatshirt", "sweater", "cardigan", "jacket", "vest"],
    "Dresses": ["dress", "jumpsuit"],
    "Outerwear": ["coat", "cape"],
    "Bottoms": ["pants", "shorts", "skirt"],
    "Accessories": ["glasses", "hat", "headband", "head covering", "tie", "glove", "watch", "belt", "leg warmer", "bag", "wallet", "tights", "stockings", "scarf", "umbrella"],
    "Footwear": ["shoe", "sock"],
    "Miscellaneous": ["hood", "collar", "lapel", "epaulette", "sleeve", "pocket", "neckline", "buckle", "zipper", "applique", "bead", "bow", "flower", "fringe", "ribbon", "rivet", "ruffle", "sequin", "tassel"]
}

inverse_categories = {
    "shirt": ["Tops"],
    "blouse": ["Tops"],
    "top": ["Tops"],
    "t-shirt": ["Tops"],
    "sweatshirt": ["Tops"],
    "sweater": ["Tops"],
    "cardigan": ["Tops"],
    "jacket": ["Tops"],
    "vest": ["Tops"],
    "dress": ["Dresses"],
    "jumpsuit": ["Dresses"],
    "coat": ["Outerwear"],
    "cape": ["Outerwear"],
    "pants": ["Bottoms"],
    "shorts": ["Bottoms"],
    "skirt": ["Bottoms"],
    "glasses": ["Accessories"],
    "hat": ["Accessories"],
    "headband": ["Accessories"],
    "head covering": ["Accessories"],
    "hair accessory": ["Accessories"],
    "tie": ["Accessories"],
    "glove": ["Accessories"],
    "watch": ["Accessories"],
    "belt": ["Accessories"],
    "leg warmer": ["Accessories"],
    "bag": ["Accessories"],
    "wallet": ["Accessories"],
    "tights": ["Accessories"],
    "stockings": ["Accessories"],
    "scarf": ["Accessories"],
    "umbrella": ["Accessories"],
    "shoe": ["Footwear"],
    "sock": ["Footwear"],
    "hood": ["Miscellaneous"],
    "collar": ["Miscellaneous"],
    "lapel": ["Miscellaneous"],
    "epaulette": ["Miscellaneous"],
    "sleeve": ["Miscellaneous"],
    "pocket": ["Miscellaneous"],
    "neckline": ["Miscellaneous"],
    "buckle": ["Miscellaneous"],
    "zipper": ["Miscellaneous"],
    "applique": ["Miscellaneous"],
    "bead": ["Miscellaneous"],
    "bow": ["Miscellaneous"],
    "flower": ["Miscellaneous"],
    "fringe": ["Miscellaneous"],
    "ribbon": ["Miscellaneous"],
    "rivet": ["Miscellaneous"],
    "ruffle": ["Miscellaneous"],
    "sequin": ["Miscellaneous"],
    "tassel": ["Miscellaneous"]
}

dummy_img = ["https://media1.popsugar-assets.com/files/thumbor/9lbTXncVPQGnEfSmz6bUrVi2c2U=/0x361:2160x1800/fit-in/792x990/filters:format_auto():upscale()/2023/10/31/714/n/1922564/a54f8b726541268637b5c5.31439943_.jpg",
             "https://media1.popsugar-assets.com/files/thumbor/WtxoCRTMOGc34pZ_R7_aMQpqq_g=/fit-in/5070x7605/filters:format_auto():extract_cover():upscale()/2022/01/11/908/n/1922564/afdcbc5161dded1fc07ed9.02895419_GettyImages-.jpg",
             "https://fashionjackson.com/wp-content/uploads/2019/02/Fashion-Jackson-Wearing-Camel-Coat-Black-Faux-Leather-Leggings-White-Sneakers-Black-Scarf-Black-Beanie-Winter-Outfit.jpg",
             "https://i.pinimg.com/564x/f9/43/56/f94356c21ba885f1c247b1aeaadcbfdc.jpg",
             "https://i.pinimg.com/564x/de/14/73/de14738ec8efce7f76b566dd8c6d5546.jpg",
             "https://www.instyle.com/thmb/c-49WvJeE3YRZPlIgrEuTI85dPI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1710690366-3b080cd878a246a9ad8a895fb798cee5.jpg",
             "https://media.gq-magazine.co.uk/photos/628dfb6e60783de8a9d33274/master/w_1600%2Cc_limit/Clothing-Essentials-21.jpg"],


app = Flask(__name__)

@app.route('/images/<int:x>', methods=['GET'])
def getImages(x):
    queryCats = request.args.getlist("category")
    numQ = random.randint(1,5)
    queryCats = random.sample(queryCats, numQ if len(queryCats)>numQ else len(queryCats))
    cat_ids = fp.getCatIds(catNms=queryCats)

    if (len(queryCats) == 0):
        img_ids = fp.getImgIds()
    else:
        print(queryCats, "\r\n", cat_ids)
        img_ids = fp.getImgIds(catIds=cat_ids)
    img_ids = random.sample(img_ids, x if len(img_ids)>x else len(img_ids))
    imgs = [fp.loadImgs(id)[0] for id in img_ids]
    
    # img_urls = [img['original_url'] for img in imgs]
    response = []
    for img in imgs:
        img_id = img['id'] 
        img_description = ""
        img_url = img['original_url']
        if len(img_url.split(":")[0]) == 0 or img_url.split(":")[0][-1] != "s":
            img_url = "s:".join(img_url.split(":"))

        # get cats and atts
        cats = {}
        # catAttMap = {}
        annIds = fp.getAnnIds(imgIds=img['id'], catIds=[], attIds=[])
        anns = fp.loadAnns(annIds)
        for i, ann in enumerate(anns):
            these_cats = fp.cats[ann["category_id"]]["name"]
            these_cats = these_cats.split(",")
            for cat in these_cats:
                cat = cat.strip()
                if cat in inverse_categories:
                    top_level = inverse_categories[cat][0]
                    atts = []
                    if len(ann["attribute_ids"]) > 0:
                        for attId in ann["attribute_ids"]:
                            atts.append(fp.attrs[attId]["name"])
                    # catAttMap[fp.cats[ann["category_id"]]["name"]] = atts
                    if top_level not in cats:
                        cats[top_level] = {}
                    cats[top_level][cat] = atts

        
        if img_url.split(".")[-1] == "jpg":
            response.append({'id': str(img_id), 'description': img_description, 'outfitURL': [img_url], "categories": cats})
    
    return jsonify(response)

if __name__ == '__main__':
    app.run(port=5002, debug=True)
