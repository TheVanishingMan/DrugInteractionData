import sys
import codecs
import nltk #import the nltk library for natural language processing
from nltk.stem.wordnet import WordNetLemmatizer #library for finding word lemmas
lmtzr = WordNetLemmatizer() #lematizer object
#Program to generate positive, negative and facts from the positive and negative examples
#with open(sys.argv[1]) as pos: #open positive file and read sentences
with codecs.open(sys.argv[1],encoding='utf-8') as pos: #open positive file and read sentences
    Poslines = pos.read().splitlines() 
#with open("negEx.txt") as neg: #open negative file and read sentences
#    Neglines = neg.read().splitlines()
sentenceIDs = {} #Dictionary for sentencesIDs and correspondingSentences
wordIDs = {} #Dictionary for wordIDs and correspondingWords
sIDCounter,wIDCounter = 1,1 #counter for uniqueness
sentences = []
filename = sys.argv[1].replace(".","_").replace("+","_").replace("-","_");
def getWordID(Value):
    '''returns ID for a particular sentence'''
    position = wordIDs.values().index(Value)
    return wordIDs.keys()[position]

def getSentenceID(Value):
    '''returns ID for a particular sentence'''
    position = sentenceIDs.values().index(Value)
    return sentenceIDs.keys()[position]
#========================================MAKE SENTENCE AND WORD IDS FOR EACH SENTENCE IN POSITIVE AND NEGATIVE EXAMPLES====================
for line in Poslines:
    sentences += nltk.sent_tokenize(line)

for line in sentences:
    sentkey = filename + "_"+"sentence"+str(sIDCounter) #key as docID_S<number>
    value = line #value is the sentence string itself stripping off "" pair
    sIDCounter += 1
    sentenceIDs[sentkey] = value #add the sentence id and sentence to the dictionary of sentence IDs
    print "{0}: {1}".format(sentkey, line)
    tokens = nltk.word_tokenize(value)
    for word in tokens:
        wordkey = sentkey+"_"+"word"+str(wIDCounter) #key as docID_W<number>
        wIDCounter += 1
        wordIDs[wordkey] = word #add the word id and word to the dictionary of word IDs
            
#for line in Neglines:
#    if line.split(":")[1] != "\"\"":
#        key = str(line.split(":")[0])+"_"+"sentence"+str(sIDCounter) #key as docID_S<number>
#        value = line.split(":")[1][1:-1] #value is the sentence string itself stripping off "" pair
#        sIDCounter += 1
#        sentenceIDs[key] = value #add the sentence id and sentence to the dictionary
#        tokens = nltk.word_tokenize(value)
#        for word in tokens:
#            key = str(line.split(":")[0])+"_"+"word"+str(wIDCounter) #key as docID_W<number>
#            wIDCounter += 1
#            wordIDs[key] = word #add the word id and word to the dictionary of word IDs
#=====================================MAKE POSITIVE AND NEGATIVE EXAMPLE PREDICATES=========================================================
#posPreds,negPreds = [],[]
#Predicates allowed:
#sentenceContainsTarget(SID,WID) DONE
#!sentenceContainsTarget(SID,WID) DONE
#for line in Poslines:
#    if line.split(":")[1] != "\"\"":
#        sentenceID = getSentenceID(line.split(":")[1][1:-1]) #get the id of the sentence in which the target is to be found
#        targetWord = str(line.split(":")[2]) #get target word
#        for word in wordIDs.values():
#            if "," in word and len(word) > 0:
#                if word.replace(",","") == targetWord:
#                    posPreds.append("sentenceContainsTarget("+sentenceID.replace("-","_")+","+getWordID(word).replace("-","_")+").")
#                    break
#for line in Neglines:
#    if line.split(":")[1] != "\"\"":
#        sentenceID = getSentenceID(line.split(":")[1][1:-1]) #get the id of the sentence in which target is not found
#        tokens = nltk.word_tokenize(value)
#        for word in tokens:
#            if word in wordIDs.values():
#                negPreds.append("sentenceContainsTarget("+sentenceID.replace("-","_")+","+getWordID(word).replace("-","_")+").")
#with open("train_pos.txt","w") as pos: #writing to files
#    for pred in posPreds:
#        pos.write(pred+"\n")
#with open("train_neg.txt","w") as neg:
#    for pred in negPreds:
#        neg.write(pred+"\n")
#======================================MAKE FACT PREDICATES=======================================================================================
Facts = [] #List of all Facts
#different facts allowed are:
#isWord(WID) DONE
#isSentence(SID) DONE
#wordInSentenceNumber(SID,WID) DONE
#SentenceContainsWord(SID,WID) DONE
#LemmaOfWordInSentence(SID,WID,<lemma>) DONE
#nextWordInSentence(SID,W1ID,W2ID) DONE
#nextOfNextWordInSentence(SID,W1ID,W2ID) DONE
#prevWordInSentence(SID,W1ID,W2ID) DONE
#prevOfPrevWordInSentence(SID,W1ID,W2ID) DONE
#POSInSentence(SID,WID,<POS>) DONE
#nextWordPOSInSentence(SID,WID,<POS>) DONE
#nextOfNextWordPOSInSentence(SID,WID,<POS>) DONE
#prevWordPOSInSentence(SID,WID,<POS>) DONE
#prevOfPrevWordPOSInSentence(SID,WID,<POS>) DONE
#wordString(WID,<string>) DONE
#wordStringInSentence(SID,WID,<string>) DONE
#beginningWordInSentence(SID,WID) DONE
#midWordInSentence(SID,WID) DONE
#endingWordInSentence(SID,WID) DONE
#==============================isWord(WID)==========================
'''for id in wordIDs: #All words are obviously words so add to facts
    Facts.append("isWord("+id+").")
'''
for id in sentenceIDs:
    print("parsing sentence id: "+id)
    #==============================isSentence(SID)==========================
    '''
    Facts.append("isSentence("+id+").") #same for all sentences
    '''
    tokens = nltk.word_tokenize(sentenceIDs[id])
    ntokens = len(tokens)
    for word in tokens:
        position = tokens.index(word) #get position of word in sentence
        lemma = lmtzr.lemmatize(word,pos='v') #get lemma of word in verb form
        #===========================POSInSentence(SID,WID,<POS>)============
        POS = nltk.pos_tag([word])[0][1]
        wordIndex = tokens.index(word)
        wordID = getWordID(word)
        Facts.append("POSInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+",\""+POS+"\").")
        #===========================#LemmaOfWordInSentence(SID,WID,<lemma>)=============
        Facts.append("LemmaOfWordInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+",\""+str(lemma)+"\").")
        #===========================#beginningWordInSentence(SID,WID)===================
        if position < ntokens/3:
            Facts.append("beginningWordInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+").")
        #===========================#midWordInSentence(SID,WID)===================
        elif position >= ntokens/3 and position < ntokens*2/3:
            Facts.append("midWordInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+").")
        #===========================#endingWordInSentence(SID,WID)===================
        elif position > ntokens*2/3:
            Facts.append("endingWordInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+").")
        #================================nextWordInSentence(SID,W1ID,W2ID) and nextWordPOSInSentence(SID,WID,<POS>)==============
        if wordIndex < ntokens-1:
            nextWordID = getWordID(tokens[wordIndex+1])
            POSnext = nltk.pos_tag([tokens[wordIndex+1]])[0][1]
            Facts.append("nextWordInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+","+nextWordID.replace("-","_")+").")
            '''
            Facts.append("nextWordPOSInSentence("+id+","+wordID+",\""+POSnext+"\").")
            '''
        #================================prevWordInSentence(SID,W1ID,W2ID) and prevWordPOSInSentence(SID,WID,<POS>)==============
        if wordIndex > 0:
            prevWordID = getWordID(tokens[wordIndex-1])
            POSprev = nltk.pos_tag([tokens[wordIndex-1]])[0][1]
            '''
            Facts.append("prevWordInSentence("+id+","+wordID+","+prevWordID+").")
            Facts.append("prevWordPOSInSentence("+id+","+wordID+",\""+POSprev+"\").")
            '''
        #================================nextOfNextWordInSentence(SID,W1ID,W2ID) and nextOfNextWordPOSInSentence(SID,WID,<POS>)==============
        if wordIndex < ntokens-2:
            nextOfNextWordID = getWordID(tokens[wordIndex+2])
            POSnextOfNext = nltk.pos_tag([tokens[wordIndex+2]])[0][1]
            '''
            Facts.append("nextOfNextWordInSentence("+id+","+wordID+","+nextOfNextWordID+").")
            Facts.append("nextOfNextWordPOSInSentence("+id+","+wordID+",\""+POSnextOfNext+"\").")
            '''
        #================================prevOfPrevWordInSentence(SID,W1ID,W2ID) and prevOfPrevWordPOSInSentence(SID,WID,<POS>)==============
        if wordIndex > 1:
            prevOfPrevWordID = getWordID(tokens[wordIndex-2])
            POSprevOfPrev = nltk.pos_tag([tokens[wordIndex-2]])[0][1]
            '''
            Facts.append("prevOfPrevWordInSentence("+id+","+wordID+","+prevOfPrevWordID+").")
            Facts.append("prevOfPrevWordPOSInSentence("+id+","+wordID+",\""+POSprevOfPrev+"\").")
            '''
        #==============================wordInSentenceNumber(SID,WID)==========
        if "," in word:
            if len(word) > 1 and nltk.pos_tag([word.replace(",","")])[0][1] == "CD": #Check if word is a number and first remove comma's like if number is 10,000,000
                Facts.append("wordInSentenceNumber("+id.replace("-","_")+","+wordID.replace("-","_")+").")
        elif nltk.pos_tag([word])[0][1] == "CD": #Numbers that dont contain commas
            Facts.append("wordInSentenceNumber("+id.replace("-","_")+","+wordID.replace("-","_")+").")
        #=========================wordStringInSentence(SID,WID,<string>) and wordString(WID,<string>)====
        '''
        Facts.append("wordString("+wordID+","+"\""+word+"\").")
        '''
        Facts.append("wordStringInSentence("+id.replace("-","_")+","+wordID.replace("-","_")+","+"\""+word+"\").")
        #=========================SentenceContainsWord(SID,WID)=============
        '''
        Facts.append("SentenceContainsWord("+id+","+wordID+").")
        '''
with open(filename+"_facts.txt","w") as facts:
    for fact in Facts:
        facts.write(fact+"\n")
