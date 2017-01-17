import gensim
from gensim.models import word2vec

sentences = gensim.models.word2vec.LineSentence('drug-words.txt')
model = word2vec.Word2Vec(sentences, size=200, window=6, min_count=2, workers=4)

