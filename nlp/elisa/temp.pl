gPats = [
  ['I need (.*)',
  [  '"Why do you need $c1"',
    '"Would it really help you to get $c1"',
    '"Are you sure you need $c1"']],

  ['Why don\'?t you ([^\?]*)\??',
  [  '"Do you really think I don\'t $c1"',
    '"Perhaps eventually I will $c1"',
    '"Do you really want me to $c1"']],

  ['Why can\'?t I ([^\?]*)\??',
  [  '"Do you think you should be able to $c1"',
    '"If you could $c1, what would you do"',
    '"I don\'t know -- why can\'t you $c1"',
    '"Have you really tried"']],

  ['I can\'?t (.*)',
  [  '"How do you know you can\'t $c1"',
    '"Perhaps you could $c1 if you tried"',
    '"What would it take for you to $c1"']],

  ['I am (.*)',
  [  '"Did you come to me because you are $c1"',
    '"How long have you been $c1"',
    '"How do you feel about being $c1"']],

  ['I\'?m (.*)',
  [  '"How does being $c1 make you feel"',
    '"Do you enjoy being $c1"',
    '"Why do you tell me you\'re $c1"',
    '"Why do you think you\'re $c1"']],

  ['Are you ([^\?]*)\??',
  [  '"Why does it matter whether I am $c1"',
    '"Would you prefer it if I were not $c1"',
    '"Perhaps you believe I am $c1"',
    '"I may be $c1 -- what do you think"']],

  ['What (.*)',
  [  '"Why do you ask"',
    '"How would an answer to that help you"',
    '"What do you think"']],

  ['How (.*)',
  [  '"How do you suppose"',
    '"Perhaps you can answer your own question"',
    '"What is it you\'re really asking"']],

  ['Because (.*)',
  [  '"Is that the real reason"',
    '"What other reasons come to mind"',
    '"Does that reason apply to anything else"',
    '"If $c1, what else must be true"']],

  ['(.*) sorry (.*)',
  [  '"There are many times when no apology is needed"',
    '"What feelings do you have when you apologize"']],

  ['Hello(.*)',
  [  '"Hello... I\'m glad you could drop by today"',
    '"Hi there... how are you today"',
    '"Hello, how are you feeling today"']],

  ['I think (.*)',
  [  '"Do you doubt $c1"',
    '"Do you really think so"',
    '"But you\'re not sure $c1"']],

  ['(.*) friend (.*)',
  [  '"Tell me more about your friends"',
    '"When you think of a friend, what comes to mind"',
    '"Why don\'t you tell me about a childhood friend"']],

  ['Yes',
  [  '"You seem quite sure"',
    '"OK, but can you elaborate a bit"']],

  ['(.*) computer(.*)',
  [  '"Are you really talking about me"',
    '"Does it seem strange to talk to a computer"',
    '"How do computers make you feel"',
    '"Do you feel threatened by computers"']],

  ['Is it (.*)',
  [  '"Do you think it is $c1"',
    '"Perhaps it\'s $c1 -- what do you think"',
    '"If it were $c1, what would you do"',
    '"It could well be that $c1"']],

  ['It is (.*)',
  [  '"You seem very certain"',
    '"If I told you that it probably isn\'t $c1, what would you feel"']],

  ['Can you ([^\?]*)\??',
  [  '"What makes you think I can\'t $c1"',
    '"If I could $c1, then what"',
    '"Why do you ask if I can $c1"']],

  ['Can I ([^\?]*)\??',
  [  '"Perhaps you don\'t want to $c1"',
    '"Do you want to be able to $c1"',
    '"If you could $c1, would you"']],

  ['You are (.*)',
  [  '"Why do you think I am $c1"',
    '"Does it please you to think that I\'m $c1"',
    '"Perhaps you would like me to be $c1"',
    '"Perhaps you\'re really talking about yourself"']],

  ['You\'?re (.*)',
  [  '"Why do you say I am $c1"',
    '"Why do you think I am $c1"',
    '"Are we talking about you, or me"']],

  ['I don\'?t (.*)',
  [  '"Don\'t you really $c1"',
    '"Why don\'t you $c1"',
    '"Do you want to $c1"']],

  ['I feel (.*)',
  [  '"Good, tell me more about these feelings"',
    '"Do you often feel $c1"',
    '"When do you usually feel $c1"',
    '"When you feel $c1, what do you do"']],

  ['I have (.*)',
  [  '"Why do you tell me that you\'ve $c1"',
    '"Have you really $c1"',
    '"Now that you have $c1, what will you do next"']],

  ['I would (.*)',
  [  '"Could you explain why you would $c1"',
    '"Why would you $c1"',
    '"Who else knows that you would $c1"']],

  ['Is there (.*)',
  [  '"Do you think there is $c1"',
    '"It\'s likely that there is $c1"',
    '"Would you like there to be $c1"']],

  ['My (.*)',
  [  '"I see, your $c1"',
    '"Why do you say that your $c1"',
    '"When your $c1, how do you feel"']],

  ['You (.*)',
  [  '"We should be discussing you, not me"',
    '"Why do you say that about me"',
    '"Why do you care whether I $c1"']],

  ['Why (.*)',
  [  '"Why don\'t you tell me the reason why $c1"',
    '"Why do you think $c1"' ]],

  ['I want (.*)',
  [  '"What would it mean to you if you got $c1"',
    '"Why do you want $c1"',
    '"What would you do if you got $c1"',
    '"If you got $c1, then what would you do"']],

  ['(.*) mother(.*)',
  [  '"Tell me more about your mother"',
    '"What was your relationship with your mother like"',
    '"How do you feel about your mother"',
    '"How does this relate to your feelings today"',
    '"Good family relations are important"']],

  ['(.*) father(.*)',
  [  '"Tell me more about your father"',
    '"How did your father make you feel"',
    '"How do you feel about your father"',
    '"Does your relationship with your father relate to your feelings today"',
    '"Do you have trouble showing affection with your family"']],

  ['(.*) child(.*)',
  [  '"Did you have close friends as a child"',
    '"What is your favorite childhood memory"',
    '"Do you remember any dreams or nightmares from childhood"',
    '"Did the other children sometimes tease you"',
    '"How do you think your childhood experiences relate to your feelings today"']],

  ['(.*)\?',
  [  '"Why do you ask that"',
    '"Please consider whether you can answer your own question"',
    '"Perhaps the answer lies within yourself"',
    '"Why don\'t you tell me"']],

  ['quit',
  [  '"Thank you for talking with me"',
    '"Good-bye"',
    '"Thank you, that will be $150.  Have a good day"']],

  ['(.*)',
  [  '"Please tell me more"',
    '"Let\'s change focus a bit... Tell me about your family"',
    '"Can you elaborate on that"',
    '"Why do you say that $c1"',
    '"I see"',
    '"Very interesting"',
    '"$c1"',
    '"I see.  And what does that tell you"',
    '"How does that make you feel"',
    '"How do you feel when you say that"']]
  ]