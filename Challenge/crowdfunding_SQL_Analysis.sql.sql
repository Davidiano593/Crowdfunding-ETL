CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);

CREATE TABLE "backers" (
    "backer_id" varchar(10)   NOT NULL,
    "cf_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_backers" PRIMARY KEY (
        "backer_id"
     )
);

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

ALTER TABLE "backers" ADD CONSTRAINT "fk_backers_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");

SELECT * FROM backers;


-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
SELECT cf_id, backers_count, outcome
FROM "campaign"
WHERE outcome='live'
ORDER BY backers_count DESC;


-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.

SELECT cf_id, COUNT(backer_id) AS "backers_count"
FROM "backers"
GROUP BY cf_id
ORDER BY "backers_count" DESC;

-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 
SELECT con.first_name,
       con.last_name,
	   con.email,
	   (cam.goal-cam.pledged) AS "Amount to goal"
INTO contact_and_amount_to_goal
FROM "contacts" AS con
JOIN "campaign" AS cam
ON (con.contact_id=cam.contact_id)
WHERE cam.outcome='live'
ORDER BY "Amount to goal" DESC;



-- Check the table

SELECT * FROM contact_and_amount_to_goal;

-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 

SELECT bac.email,
       bac.first_name,
	   bac.last_name,
	   cam.cf_id,
	   cam.company_name,
	   cam.description,
	   cam.end_date,
	   (cam.goal-cam.pledged)AS"Left of Goal"
INTO email_backers_remaining_goal_amount
FROM "backers" AS bac
JOIN "campaign" AS cam
ON  (bac.cf_id=cam.cf_id)
WHERE cam.outcome='live'
ORDER BY bac.email DESC;
-- Check the table

SELECT *FROM email_backers_remaining_goal_amount;



















