var db=require('./db_connection');
var objectId = require('mongodb').ObjectID


module.exports={
    getReports:()=>{
        return new Promise(async(resolve,reject)=>{
            let reports=await db.get().collection('accreport').aggregate([
                {
                    "$sort":{"_id":-1}
                },
                {
                    "$match":{fire: { $nin : ["0"] }}
                },
                {
                    "$lookup": {
                        "from": "user",
                        "let": { "userObjId": { "$toObjectId": "$userid" } },
                        "pipeline": [
                            { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } }}
                        ],
                        "as": "user"
                    },
                }
            ]).toArray()
            resolve(reports)
        })
    },
    getDetail:(accid)=>{
        return new Promise(async(resolve,reject)=>{
            let iid = objectId(accid)
            let response=await db.get().collection('accreport').aggregate([
                {
                    '$match': {
                      '_id': iid
                    }
                  },
                  { "$lookup": {
                    "let": { "userObjId": { "$toObjectId": "$userid" } },
                    "from": "user",
                    "pipeline": [
                      { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } } }
                    ],
                    "as": "user"
                  }}
            ]).toArray()
            resolve(response)
        })
    },
    fireView:async (accid)=>{
        let id = objectId(accid);
        db.get().collection('accreport').findOne({_id:id},function(err,result){
            if(result.fire === '1'){
                db.get().collection('accreport').updateOne({_id:id}, {$set: {'fire':'10'}});
            }else{}
        });
    },
    fireAccept:async (accid)=>{
        return new Promise(async(resolve,reject)=>{
            let id = objectId(accid)
            let response=await db.get().collection('accreport').updateOne({_id:id}, {$set: {'fire':'11'}})
            resolve(response)
        })
    },
}