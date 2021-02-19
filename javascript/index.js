#!/usr/bin/env node
"use strict"

const { readFileSync } = require('fs');

let fs = require('fs');
const USERS_FILE_PATH = 'data/users.json';
const EVENTS_FILE_PATH = 'data/events.json';
const VISITED_HOME_PAGE = 'Visited home page';
const PURCHASED_ITEMS = 'Purchased items in cart';
const VISITED_BLOG_POST = 'Visited blog post';
const ADDED_ITEM_TO_CART = 'Added item to cart';

/**
 * 
 * @param {String} filePath 
 * @param {*} encoding
 */
async function readFile(filePath, encoding = 'utf8') {
    let data = await fs.readFileSync(filePath, encoding);
    return data;
}

function firstQuestionAnswer(events) {
    return `First Question Answer is: ${events.length || 0}`;
}

function secondQuestionAnswer(events, users, uniqueUserIds) {
    let ageSum = 0;
    uniqueUserIds.forEach((userId) => {
        let user = users[`${userId}`];
        if (user) {
            ageSum += user.age;
        }
    });
    let average = ageSum / (uniqueUserIds.length || 1); // or 1 to avoid dividing by 0
    return `Second Question Answer is: ${average}`;
}

// I will assume that conversion rate = (number of purchases x 100) / (number of homepage unique visitors)
// I got it from here: https://en.ryte.com/wiki/Conversion_Rate
/**
 * 
 * @param {Array<{name,timestamp,user_id}>} sortedEvents
 * @param {Array<Number>} uniqueUserIds
 */
function thirdQuestionAnswer(sortedEvents, uniqueUserIds) {
    let userVisits = {};
    let purchaseCount = 0;
    // Here 1 means user visited homepage , 2 means that he/her purchased an item
    // we dont need to add conditions for multiple purchases since the maximum count is 1
    sortedEvents.forEach((event) => {
        if (!userVisits[event.user_id] && event.name == VISITED_HOME_PAGE) {
            userVisits[event.user_id] = 1;
        }
        else if (userVisits[event.user_id] == 1 && event.name == PURCHASED_ITEMS) {
            purchaseCount += 1;
            userVisits[event.user_id] = 0; // clear user visit to check if the user will visit homepage and then purchase again
        }
    });
    let conversionRate = ((purchaseCount * 100) / (uniqueUserIds.length || 1));
    return `Third Question Answer is: ${conversionRate}`;
}

/**
 * 
 * @param {Array<{name,timestamp,user_id}>} sortedEvents
 */
function forthQuestionAnswer(sortedEvents) {
    let userVisits = {};
    let trackedVisits = {};

    sortedEvents.forEach((event) => {
        if (!userVisits[event.user_id] && event.name == VISITED_HOME_PAGE) {
            userVisits[event.user_id] = 1;
        }
        else if (userVisits[event.user_id] == 1 && event.name != VISITED_HOME_PAGE) {
            if(trackedVisits[event.name]){
                trackedVisits[event.name] += 1;
            }
            else{
                trackedVisits[event.name] = 1;
            }
        }
    });
    let mostFrequentVisits = Object.keys(trackedVisits).sort(function(a,b){return trackedVisits[b] - trackedVisits[a]})
    return `Forth Question Answer is: 1- ${mostFrequentVisits[0]} , 2- ${mostFrequentVisits[1]} , 3- ${mostFrequentVisits[2]}`
}

/**
 * 
 * @param {Array<{name,timestamp,user_id}>} sortedEvents
 * @description I will assume here that the flow of events from visiting blog post to 
 * purchasing an item will be by timestamp , i also assume that every unique user has
 * a unique path to take for simplicity
 * If user path visits step 1 and 2 and 3 (visited blog , added item to cart , purchased item)
 * Then it is a valid path
 */
function fifthQuestionAnswer(sortedEvents){
    let userVisits = {};
    let trackedVisits = {};
    sortedEvents.forEach((event) => {
        if (!userVisits[event.user_id] && event.name == VISITED_BLOG_POST) {
            userVisits[event.user_id] = {
                step: 1,
                path: VISITED_BLOG_POST
            }
        }
        else if(userVisits[event.user_id]){
            if(userVisits[event.user_id].step == 1 && event.name == ADDED_ITEM_TO_CART){
                userVisits[event.user_id].step = 2;
                userVisits[event.user_id].path += ` => ${event.name}`;
            }
            else if(userVisits[event.user_id].step == 2){
                if(event.name == PURCHASED_ITEMS){
                    userVisits[event.user_id].step = 3;
                }
                userVisits[event.user_id].path += ` => ${event.name}`;
            }
            else if(userVisits[event.user_id].step == 3){
                if(event.name == ADDED_ITEM_TO_CART || event.name == PURCHASED_ITEMS){
                    userVisits[event.user_id].path += ` => ${event.name}`;
                    if(event.name == PURCHASED_ITEMS){
                        if(trackedVisits[userVisits[event.user_id].path]){
                            trackedVisits[userVisits[event.user_id].path] += 1;
                        }
                        else{
                            trackedVisits[userVisits[event.user_id].path] = 1;
                        }
                    }
                }
            }
        }
    });
    let mostFrequentPath = Object.keys(trackedVisits).sort(function(a,b){return trackedVisits[b] - trackedVisits[a]})
    return `Fifth Question Answer is: ${mostFrequentPath[0]}`;
}

/**
 * 
 * @param {Array<{name,timestamp,user_id}>} events 
 */
function gethomepageUniqueUsers(events) {
    let uniqueUserIds = [];
    events.forEach((event) => {
        if (event.name == VISITED_HOME_PAGE) {
            let index = uniqueUserIds.indexOf(event.user_id);
            if (index == -1) {
                uniqueUserIds.push(event.user_id);
            }
        }
    });
    return uniqueUserIds;
}

/**
 * 
 * @param {Array<{name,timestamp,user_id}>} a 
 * @param {Array<{name,timestamp,user_id}>} b 
 * @description this Function is used to sort events ascendingly by timestamp
 */
function compare(a, b) {
    return a.timestamp - b.timestamp;
}

(async () => {
    let usersFile = await readFile(USERS_FILE_PATH);
    let eventsFile = await readFile(EVENTS_FILE_PATH);
    let users = JSON.parse(usersFile).users;
    let events = JSON.parse(eventsFile).events;
    let sortedEvents = events.sort(compare);
    let uniqueUserIds = gethomepageUniqueUsers(events);
    console.log(firstQuestionAnswer(events));
    console.log(secondQuestionAnswer(events, users, uniqueUserIds));
    console.log(thirdQuestionAnswer(sortedEvents, uniqueUserIds));
    console.log(forthQuestionAnswer(sortedEvents));
    console.log(fifthQuestionAnswer(sortedEvents));
})();

