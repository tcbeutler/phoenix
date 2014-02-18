FORMAT: X-1A
PROPOSALVERSION: 0.0.3

# MEDSEEK•Influence

##User Login
Description of resources required for `authentication` workflows.

###Resources
- [`sessions`](/authentication#page:sessions) includes creating sessions and answering challenges.
- [`settings`](/authentication#page:settings) cover business logic settings configured in backend systems.
- [`users`](/authentication#page:users)

###Workflows

####I. Happy Path Login
  1. [POST /sessions {auth header username:password}](/authentication#page:sessions,header:sessions-getting-a-session-post)  
  2. No challenge in response - success

####II. Login with Challenge
  1. [POST /sessions {auth header username:password}](/authentication#page:sessions,header:sessions-getting-a-session-post)
  2. Answer challenge fields from response body.
  3. [PUT /sessions/{:sessionId}](/authentication#page:sessions,header:sessions-managing-a-session-put)
  4. Login successful.

####III. Forgot Username
  1. [GET /settings/users/challenges/username](/authentication#page:settings,header:settings-retrieve-username-challenge-settings-get) for challenge fields.
  2. Answer questions for challenge, such as email and name.
  3. [POST /users/challenges?type=username](/authentication#page:users,header:users-create-user-challenges-post) Post challenge field answers.
  4. Email is sent to user for username recovery.

####IV. Forgot Password
  1. [GET /settings/users/challenges/password](/authentication#page:settings,header:settings-retrieve-password-challenge-settings-get) for challenge fields.
  2. Answer challenge fields from response body.
  3. [POST /users/challenges?type=password](/authentication#page:users,header:users-create-user-challenges-post)] Post challenge field answers.
  4. Email is sent. User clicks url inside email.
  5. [GET /users/challenges/{:uuid}?type=secretQuestions](/authentication#page:users,header:users-manage-user-challenge-get) Get the user's secret questions.
  6. [PUT /users/challenges/{:uuid}](/authentication#page:users,header:users-manage-user-challenge-put) Update the challenge with secret question answers using the UUID provided in the email click-through link.
  7. [PUT /users/{:userId}/password]() Update user password.  
      ***NOTE: Need to work out token passed from response of [6] to allow [7].***

####V. Set Security Questions
  1. [GET /settings/users/securityQuestions](/authentication#page:settings,header:settings-security-question-choices-get) Get available user security questions from settings.
  2. [PUT /user/{:userId}/securityQuestions](/authentication#page:users,header:users-user-security-questions-put) Update user-specific security questions and answers.

#Group Sessions

# Getting a session [/sessions]
This resource focuses on creating sessions and answering challenges to authenticate a session.  
Response only includes challengeQuestions if challenge must be answered.

### Create a session [POST]

+ Request Authorization Header

    + Headers

        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

    + Body

      { rememberMe: bool }

+ Response 201 (application/json)

    + Body

        {  
          href: /sessions/{:sessionId},
          results: {
            username: string,
            userId: string,
            sessionId: string,
            twoFactorAuthToken: string,
            sessionAuthenticated: bool
            challengeQuestions: [
              {
                questionId: int,
                question: "question1 string goes here",
              },
              {
                questionId: int,
                question: "question2 string goes here"
              }
            ]
        }

# Managing a session [/sessions/{:sessionId}]

### Answer a session login challenge [PUT]

+ Request Authorization Header and Body

    + Headers

        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

    + Body

        {
          challengeQuestions: [
            {
              questionId: int,
              question: "question1 string goes here",
              answer: "answer1 string goes here"
            },
            {
              questionId: int,
              question: "question2 string goes here",
              answer: "answer2 string goes here"
            }
          ]        
        }

+ Response 200

    + Body

        {  
          href: /sessions/{:sessionId},
          results: {
            username: string,
            userId: string,
            sessionId: string,
            twoFactorAuthToken: string,
            sessionAuthenticated: bool
        }
#Group Settings
A settings resource allows business logic settings to be abstracted in such a way that they can be either retrieved from the backend system, stored in the facade layer, or stored in another manner entirely.
The settings resource should being with `settings` and mirror the URI template of the resource the settings are for.

# All Settings [/settings]

### Retrieve settings [GET]

+ Response All settings

    + Body

        {
          href: /settings
          results: [
            href: /settings,
            users: {
              href: /settings/users,
              challenges: {
                href: /settings/users/challenges,
                username: {
                  href: /settings/users/challenges/username,
                  challengeFieldName1: string,
                  challengeFieldName2: string
                },
                password: {
                  href: /settings/users/challenges/password,
                  challengeFieldName1: string,
                  challengeFieldName2: string,
                }
              }
            }
          ]
        }

# Retrieve username challenge settings [/settings/users/challenges/username]

### [GET]

+ Response 200

    + Body

        {
          href: /settings/users/challenges/username,
          fields: [
           string1,
           string2 
          ]
        }

# Retrieve password challenge settings [/settings/users/challenges/password]

### [GET]

+ Response 200

    + Body

        {
          href: /settings/users/challenges/password,
          fields: [
            string1,
            string2
          ]
        }

# Security question choices [/settings/users/securityQuestions]

### Get possible questions [GET]

+ Response

    + Body

        {
            href: /settings/users/securityQuestions,
            questions: [
              string1,
              string2,
              string3
            ]
        }
#Group Users
Users resource represents all information relating to a user as authenticated.

# Create user challenges [/users/challenges]

### Create a challenge [POST]

+ Parameters

    + type (required, string)

        Type of challenge answer.

        + Values

            + `username`
            + `password`

+ Request

    + Body

        {
            challengeFieldName1: "answer1 string goes here",
            challengeFieldName2: "answer2 string goes here",
        }
+ Response 204

+ Response 403

    + Body

        {
            status: 403,
            code: string,
            message: string,
            developerMessage: string,
            stack: string,
            tracking: uuid string
        }

# Manage User challenge [/users/challenges/{uuid}]

### Get security questions [GET]

+ Parameters

    + type (string)

        Type of challenge.

        + Values

            + `securityQuestion`

+ Response 200

    + Body

        {
            href: /users/challenges/{:uuid}?type=securityQuestions,
            securityQuestion [
              {
                questionId: int,
                question: "question1 string goes here"
              },
              {
                questionId: int,
                question: "question2 string goes here"
              }
            ]
        }

### Answer security questions [PUT]

+ Request
    
    + Body

        {
            href: /users/challenges/{:uuid},
            challengeQuestions: [
              {
                questionId: int,
                question: "question1 string goes here",
                answer: "answer1 string goes here"
              },
              {
                questionId: int,
                question: "question1 string goes here",
                answer: "answer1 string goes here"
              }
            ]
        }

+ Response 204

+ Response 403

# User password [/users/{userId}/password]

### Update user passsword [PUT]

+ Request

    + Body

        {
            key: "authenticatonTokenKey string"
            newPassword: string
        }

+ Response 204

+ Response 403

# User security questions [/users/{:userId}/securityQuestions]

### Set user security questions [PUT]

+ Request Auth Header and Body

    + Header

        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

    + Body

        {
            securityQuestions: [
              {
                questionId: int,
                question: "question1 string goes here",
                answer: "answer1 string goes here"
              },
              {
                questionId: int,
                question: "question2 string goes here",
                answer: "answer2 string goes here"
              }
            ]
        }

+ Response 204
