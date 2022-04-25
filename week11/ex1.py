from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost")
db = client['test']

def display_rest(cursor):
    for item in cursor:
       print(f"{item['name']}, {item['borough']}, {item['address']['street']}, {item['address']['building']} - {item['cuisine']} cuisine") 

def ex1():
    cursor = db.restaurants.find({'cuisine':'Indian'})
    display_rest(cursor)
    print('------')
    cursor = db.restaurants.find({'$or':[{'cuisine':'Indian'}, {'cuisine':'Thai'}]})
    display_rest(cursor)
    print('------')
    cursor = db.restaurants.find({'address.building':'1115', 'address.street':'Rogers Avenue', 'address.zipcode':'11226'})
    display_rest(cursor)
    print('------')


def ex2():
    record = {'borough':'Manhattan', 'cuisine':'Italian', 'name':'Vella', 'restaurant_id':'41704620', 'grades':[{'date': {'$date': '2014-10-01'}, 'grade':'A', 'score':11}], 'address':{'building':1480, 'street':'2 Avenue', 'zipcode':'10075', 'coord':[-73.9557413, 40.7720266]}}
    db.restaurants.insert_one(record)

def ex3():
    db.restaurants.delete_one({'borough':'Manhattan'})
    db.restaurants.delete_many({'cuisine':'Thai'})

def ex4():
    cursor = db.restaurants.find({'address.street':'Rogers Avenue'})
    count_C = 0
    removed = False
    for item in cursor:
        grades = item['grades']
        for gr in grades:
            if gr['grade'] == 'C':
                count_C += 1
            if (count_C > 1):
                db.restaurants.delete_one(item)
                removed = True
        if(not removed):
            d = datetime.datetime.now()
            db.restaurants.update_one({'_id':item['_id']}, {'$push': {'grades' : {'date':d, 'grade':'C', 'score':35}}})


def main():
    print('run ex1')
    ex1()
    print('run ex2')
    ex2()
    print('run ex3')
    ex3()
    print('run ex4')
    ex4()
    print('done')

if __name__ == "__main__":
    main()
