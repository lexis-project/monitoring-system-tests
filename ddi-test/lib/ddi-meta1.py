import pdb

l=[{
        "eudat": {},
        "location": {
            "access": "public",
            "internalID": "69c0f740-33f0-11eb-8885-0050568fcebc",
            "project": "testproject"
        },
        "metadata": {
            "AlternateIdentifier": [],
            "CustomMetadataSchema": [],
            "contributor": [],
            "creator": [
                "LRZ LEXIS TEAM"
            ],
            "owner": [],
            "publisher": [],
            "relatedIdentifier": [],
            "rights": [],
            "rightsIdentifier": [],
            "rightsURI": [],
            "title": "testdata"
        }
    }]

i="69c0f740-33f0-11eb-8885-0050568fcebc"

def find_by_internalid (list, internalid):
    r= [value for value in list if value["location"]["internalID"] == internalid]
    print ("r=",r)
    print ("internalid=",internalid)
    return r
