# This Application Reads in a Text Document      #
# Then It Lists all the Words and Word Counts    #
# After Reading all the Words We Try and Extract #
# All the Keywords and Features that we Want     #

##########################################
# Step 1: Import the Data Collection Set #
##########################################

# We Create an Array to Contain the List of Training Documents #
trainingDocuments = []

# The Training Documents Are in the Folder Test Files #
# Which Can Be Accessed from the Parent Directory     #
# First We Change Into the Test Folder Directory      #
Dir.foreach("../test"){
  |trainingFileName|

  # Then If the File Name is a Period or Double Period  #
  # We Do Not Include It as a File Name Since It is a   #
  # Directory Listing or Folder Listing not a File Name #
  if trainingFileName == "." or trainingFileName == ".."

  # If It Is Not a Period We Add the Training File #
  # To the Training Documents Array                #
  else

    # We Add '../test/' In Front of the File Name To #
    # Give an Absolute Path to the Training Files    #
    trainingFileName = "../test/" + trainingFileName

    # We Then Add the Training Files to the Array of Documents #
    trainingDocuments << trainingFileName

  end
}

#################################################
# End of Step 1: Import the Data Collection Set #
#################################################

#################################################################
# Step 2: Collect and Extract Data from the Data Collection Set #
#################################################################

# Now We Have Obtained the List of Training Documents      #
# And Store the List of Training Documents In an Array     #
# We Will Now Try to Create Various N-Gram Language Models #
# For the Purposes of the Project, We Will Simply Make     #
# Unigram, Bigram, and Trigram Language Models, Although   #
# From Observing the Training Files, We Feel that Bigram   #
# Language Models Will Be the Best Language Model for Our  #
# Particular Scenario                                      #
# We First Create an Array That Will Contains All The      #
# Words In Each Document. The Index of the Array Contains  #
# The Document Number It Corresponds To.                   #
arrayOfDocumentsAndWordsSequentiallyInEachDocument = []

# First We Go Through Each File or Data Set #
# And We Collect the Words in Sequence So   #
# The Words Can Eventually Be Analyzed as a #
# N-Gram Model                              #
trainingDocuments.each{
  |trainingfilename|

  # We Create an Array to Sequentially Record the Words #
  # That Are Read in From the Training Documents        #
  allWordsSequentiallyInCurrentDocument = []

  # We Create a Loop To Read in the Data    #
  # From the Current Training File and      #
  # To Catch Exceptions to Reading the File #
  begin

    # We Create or Open the Training Document #
    trainingfile = File.open(trainingfilename, "r")

    # Next We Read In the Textual Data, Line By #
    # Line and Process Each Word Individually   #
    # Within the Document                       #
    trainingfile.each_line{
      |trainingline|

      # Within Each Line We Split the Line   #
      # Based on a Blank Space and We Filter #
      # Out Control and Escape Characters    #
      # From the Words and Text              #
      # We Need to Better Understand How to  #
      # Remove Such Characters and Symbols   #
      trainingline = trainingline.gsub(/[({,?!\"=<&>:;.})]/, '')
      trainingline = trainingline.gsub(/\//, ' ')
      trainingline = trainingline.gsub(/-/, '')
      trainingline = trainingline.gsub(/_/, ' ')
      trainingline = trainingline.gsub(/\*+/, '')
      trainingline = trainingline.gsub(/$/, '')

      # We Then Split the Line Into Individual  #
      # Words and Store the Words Into an Array #
      trainingwords = trainingline.split

      # We Then Process Each Word From the Array #
      trainingwords.each{
        |trainingword|

        # For Each Word We Lower Case or Down #
        # Case Each Word for Comparisons And  #
        # We Strip End of Line Characters     #
        # We Might Also Want to Do Some       #
        # Removal of Control Characters       #
        trainingword = trainingword.strip
        trainingword = trainingword.downcase

        # We Then Add Each Word to the Array      #
        # Since We Are Storing the Words In Order #
        allWordsSequentiallyInCurrentDocument << trainingword
      }
    }

    # Once We Are Done Processing All Words for #
    # the Current Training Document We Add the  #
    # Array Containing the Sequential List of   #
    # Words In the Document to the Larger Two   #
    # Dimensional Array Containing the Document #
    # and the List of All the Words             #
    arrayOfDocumentsAndWordsSequentiallyInEachDocument << allWordsSequentiallyInCurrentDocument

    # We Appropriately Close the File for Safety Reasons #
    trainingfile.close

  # Here We Use the Rescue Function to Catch #
  # Exceptions When Trying to Read the File  #
  rescue => error

    # We Print Out the Exception If There Is One #
    print "Exception: #{error}"
    error

  end
}

####################################################################
# End of Step 2: Collect and Extract Data from Data Collection Set #
####################################################################

#####################################################
# Step 3: Remove Stop Words from the Data Extracted #
#####################################################

# Now We Read In the Stop Words Text File   #
# Which Contains a List of Common Stop      #
# Words and Try to Remove the Stop Words    #
# From the Two Dimensional Matrix Which     #
# Will Allow Use to Remove the Stop Words   #
# In Each Document and From the Entire List #
stopWordsFileName = "stopwords.txt"

# We Also Create an Array to Contain the List of Stop Words #
stopWordsList = []

begin

  # We Create or Open the File That Contains the #
  # List of the Stop Words for Processing        #
  stopWordsFile = File.open(stopWordsFileName, 'r')

  # Next We Read In the Textual Data, Line By Line #
  # And Obtain the List of the Stop Words Since    #
  # Each Line Contains an Individual Stop Word     #
  stopWordsFile.each_line{
    |stopword|

    # For Each Stop Word We Lower Case or Down        #
    # Case the Word and Remove End of Line Characters #
    # We Have Not Removed Any Punctuation Since We    #
    # Feel that the Stop Word Text File is Perfectly  #
    # Formatted, If Not We Would Need to Remove       #
    # Control Character and Other Characters As Well  #
    stopword = stopword.downcase
    stopword = stopword.strip

    # We Then Add the Stop Word to the List of Stop Words #
    stopWordsList << stopword
  }

  # We Appropriately Close the File for Reading for Safety Reasons #
  stopWordsFile.close

# Here We Use the Rescue Function to Catch #
# Exceptions When Trying to Read the File  #
# stopwords.txt Text Document              #
rescue => error

  # We Print Out the Exception If There Is One #
  print "Exception: #{error}"
  error

end

# Now We Will Attempt to Remove the Stop Words  #
# From the Matrix of Words Gathered From the    #
# Training Data Documents                       #
# The First Array's Index Corresponds to a      #
# Document Number and the Second Array Contains #
# the List of All the Words in the Document     #
arrayOfDocumentsAndWordsSequentiallyInEachDocument.each{
  |trainingfile|

  # Now We Loop Through the Array Containing #
  # All the Words in the Document            #
  trainingfile.each{
    |trainingword|

    # We Loop Through the Stop Words and If       #
    # The Training Word is a Stop Word, We Remove #
    # The Stop Word From the Array                #
    stopWordsList.each{
      |stopword|

      # If a Training Word Equal a Stop Word We Remove #
      # It From the Array of All the Words in the List #
      if trainingword == stopword
        trainingfile.delete(trainingword)
      end
    }
  }
}

########################################################
# End of Step 3: Remove Stop Words from Data Extracted #
########################################################

###########################################################
# Step 4: Create a Uni-Gram Model from the Language Model #
###########################################################

# Now Our Matrix Contains All the Words In Order #
# With All the Stop Words Removed, So We Can Now #
# Continue With Our Analysis of Words            #
# We Create Another Hash Table That Contains     #
# A List of All Uni-Grams Across All Documents   #
# and The Total Frequencies                      #
unigramLanguageModelTotalFrequenciesOfWords = Hash.new

# We Also Create An Array to Contain the Uni-Grams #
# Within Each Individual Document Where the Index  #
# Of the Array Corresponds to the Document Number  #
unigramLanguageModelFrequenciesPerDocument = []

# We Loop Through All the Documents to Collect the #
# Uni-Grams Or One Word Phrases From Each Document #
arrayOfDocumentsAndWordsSequentiallyInEachDocument.each{
  |trainingfile|

  # We Create a Hash Table for Each Document   #
  # Which May Be Used for Analysis             #
  # This Hash Table Contains the List of Words #
  # Within the Document and Their Frequencies  #
  unigramLanguageModelFrequenciesPerDocumentHash = Hash.new

  # We Create a For Loop to Be Able to Generate the Uni-Grams    #
  # We Utilize a For Loop So We Can Easily Expand to N-Grams     #
  # As We Expand to N-Grams We Go from 1...Length and Then So On #
  for i in (0...trainingfile.length)

    # We Store the Uni-Grams Temporary Variable to be Put Into the Hashes #
    unigramPhrase = trainingfile[i]

    # We Add the Uni-Gram to the Hash Table for All Documents #
    if unigramLanguageModelTotalFrequenciesOfWords.has_key?(unigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      unigramLanguageModelTotalFrequenciesOfWords[unigramPhrase] = unigramLanguageModelTotalFrequenciesOfWords[unigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      unigramLanguageModelTotalFrequenciesOfWords[unigramPhrase] = 1

    end

    # In Addition, We Add the Uni-Gram to the Hash for Each #
    # Individual Document for Analysis Purposes             #
    if unigramLanguageModelFrequenciesPerDocumentHash.has_key?(unigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      unigramLanguageModelFrequenciesPerDocumentHash[unigramPhrase] = unigramLanguageModelFrequenciesPerDocumentHash[unigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      unigramLanguageModelFrequenciesPerDocumentHash[unigramPhrase] = 1

    end
  end

  # Once We Have Processed the Training File  #
  # We Add the Document Based Frequencies to  #
  # the Array Whose Indexes Correspond to the #
  # Various Document Numbers                  #
  unigramLanguageModelFrequenciesPerDocument << unigramLanguageModelFrequenciesPerDocumentHash
}

# So At This Point, We Have Removed All the Stop Words #
# And We Have Hash Tables for Each Individual Document #
# And for the Overall Set of Documents                 #
# We Now Print Out a CSV File Which Can Be Read Into   #
# Microsoft Excel for Analytical Purposes              #
outputOfUniGramModelFileName = "OutputOfUniGramModel.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfUniGramModelFile = File.open(outputOfUniGramModelFileName, 'w')
outputOfUniGramModelFile.print "Uni-Gram Phrase,Frequency Count\n"

# Now We Can Print Out the Hash Table of All the Documents      #
# To the CSV File for Analysis, We Could Also Print Out the     #
# Hash Table for Each Individual Document, But We Don't For Now #
unigramLanguageModelTotalFrequenciesOfWords.sort{
  |a, b|

  # We Sort the List of Uni-Grams From High Frequency to Low Frequency #
  b[1] <=> a[1]
}.each{
  |unigramPhrase|

  # For Each Uni-Gram Phrase, We Just Output It and Its Frequency to the File #
  outputOfUniGramModelFile.print "#{unigramPhrase[0]},#{unigramPhrase[1]}\n"
}

# Now We Appropriately Close the File for Writing for Safety Reasons #
outputOfUniGramModelFile.close

##################################################################
# End of Step 4: Create a Uni-Gram Model from the Language Model #
##################################################################

##########################################################
# Step 5: Create a Bi-Gram Model from the Language Model #
##########################################################

# Now Our Matrix Contains All the Words In Order #
# With All the Stop Words Removed, So We Can Now #
# Continue With Our Analysis of Words            #
# We Create Another Hash Table That Contains     #
# A List of All Bi-Grams Across All Documents    #
# and The Total Frequencies                      #
bigramLanguageModelTotalFrequenciesOfPhrases = Hash.new

# We Also Create An Array to Contain the Bi-Grams #
# Within Each Individual Document Where the Index #
# Of the Array Corresponds to the Document Number #
bigramLanguageModelFrequenciesPerDocument = []

# We Loop Through All the Documents to Collect the #
# Bi-Grams Or Two Word Phrases From Each Document  #
arrayOfDocumentsAndWordsSequentiallyInEachDocument.each{
  |trainingfile|

  # We Create a Hash Table for Each Document     #
  # Which May Be Used for Analysis               #
  # This Hash Table Contains the List of Phrases #
  # Within the Document and Their Frequencies    #
  bigramLanguageModelFrequenciesPerDocumentHash = Hash.new

  # We Create a For Loop to Be Able to Generate the Bi-Grams     #
  # We Utilize a For Loop So We Can Easily Expand to N-Grams     #
  # As We Expand to N-Grams We Go from 1...Length and Then So On #
  for i in (1...trainingfile.length)

    # We Store the Bi-Grams Temporary Variable to be Put Into the Hashes #
    bigramPhrase = trainingfile[i-1] + " " + trainingfile[i]

    # We Add the Bi-Gram to the Hash Table for All Documents #
    if bigramLanguageModelTotalFrequenciesOfPhrases.has_key?(bigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      bigramLanguageModelTotalFrequenciesOfPhrases[bigramPhrase] = bigramLanguageModelTotalFrequenciesOfPhrases[bigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      bigramLanguageModelTotalFrequenciesOfPhrases[bigramPhrase] = 1

    end

    # In Addition, We Add the Bi-Gram to the Hash for Each #
    # Individual Document for Analysis Purposes            #
    if bigramLanguageModelFrequenciesPerDocumentHash.has_key?(bigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      bigramLanguageModelFrequenciesPerDocumentHash[bigramPhrase] = bigramLanguageModelFrequenciesPerDocumentHash[bigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      bigramLanguageModelFrequenciesPerDocumentHash[bigramPhrase] = 1

    end
  end

  # Once We Have Processed the Training File  #
  # We Add the Document Based Frequencies to  #
  # the Array Whose Indexes Correspond to the #
  # Various Document Numbers                  #
  bigramLanguageModelFrequenciesPerDocument << bigramLanguageModelFrequenciesPerDocumentHash
}

# So At This Point, We Have Removed All the Stop Words #
# And We Have Hash Tables for Each Individual Document #
# And for the Overall Set of Documents                 #
# We Now Print Out a CSV File Which Can Be Read Into   #
# Microsoft Excel for Analytical Purposes              #
outputOfBiGramModelFileName = "OutputOfBiGramModel.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfBiGramModelFile = File.open(outputOfBiGramModelFileName, 'w')
outputOfBiGramModelFile.print "Bi-Gram Phrase,Frequency Count\n"

# Now We Can Print Out the Hash Table of All the Documents      #
# To the CSV File for Analysis, We Could Also Print Out the     #
# Hash Table for Each Individual Document, But We Don't For Now #
bigramLanguageModelTotalFrequenciesOfPhrases.sort{
  |a, b|

  # We Sort the List of Bi-Grams From High Frequency to Low Frequency #
  b[1] <=> a[1]
}.each{
  |bigramPhrase|

  # For Each Bi-Gram Phrase, We Just Output It and Its Frequency to the File #
  outputOfBiGramModelFile.print "#{bigramPhrase[0]},#{bigramPhrase[1]}\n"
}

# Now We Appropriately Close the File for Writing for Safety Reasons #
outputOfBiGramModelFile.close

#################################################################
# End of Step 5: Create a Bi-Gram Model from the Language Model #
#################################################################

###########################################################
# Step 6: Create a Tri-Gram Model from the Language Model #
###########################################################

# Now Our Matrix Contains All the Words In Order #
# With All the Stop Words Removed, So We Can Now #
# Continue With Our Analysis of Words            #
# We Create Another Hash Table That Contains     #
# A List of All Tri-Grams Across All Documents   #
# and The Total Frequencies                      #
trigramLanguageModelTotalFrequenciesOfPhrases = Hash.new

# We Also Create An Array to Contain the Trii-Grams #
# Within Each Individual Document Where the Index  #
# Of the Array Corresponds to the Document Number  #
trigramLanguageModelFrequenciesPerDocument = []

# We Loop Through All the Documents to Collect the   #
# Tri-Grams Or Three Word Phrases From Each Document #
arrayOfDocumentsAndWordsSequentiallyInEachDocument.each{
  |trainingfile|

  # We Create a Hash Table for Each Document     #
  # Which May Be Used for Analysis               #
  # This Hash Table Contains the List of Phrases #
  # Within the Document and Their Frequencies    #
  trigramLanguageModelFrequenciesPerDocumentHash = Hash.new

  # We Create a For Loop to Be Able to Generate the Tri-Grams    #
  # We Utilize a For Loop So We Can Easily Expand to N-Grams     #
  # As We Expand to N-Grams We Go from 1...Length and Then So On #
  for i in (2...trainingfile.length)

    # We Store the Tri-Grams Temporary Variable to be Put Into the Hashes #
    trigramPhrase = trainingfile[i-2] + " " + trainingfile[i-1] + " " + trainingfile[i]

    # We Add the Tri-Gram to the Hash Table for All Documents #
    if trigramLanguageModelTotalFrequenciesOfPhrases.has_key?(trigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      trigramLanguageModelTotalFrequenciesOfPhrases[trigramPhrase] = trigramLanguageModelTotalFrequenciesOfPhrases[trigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      trigramLanguageModelTotalFrequenciesOfPhrases[trigramPhrase] = 1

    end

    # In Addition, We Add the Tri-Gram to the Hash for Each #
    # Individual Document for Analysis Purposes             #
    if trigramLanguageModelFrequenciesPerDocumentHash.has_key?(trigramPhrase)

      # We Increment the Frequency Count If We Have Seen the Phrase Before #
      trigramLanguageModelFrequenciesPerDocumentHash[trigramPhrase] = trigramLanguageModelFrequenciesPerDocumentHash[trigramPhrase] + 1

    else

      # If We Do Not See the Phrase Before, We Set the Frequency Count to 1 #
      trigramLanguageModelFrequenciesPerDocumentHash[trigramPhrase] = 1

    end
  end

  # Once We Have Processed the Training File  #
  # We Add the Document Based Frequencies to  #
  # the Array Whose Indexes Correspond to the #
  # Various Document Numbers                  #
  trigramLanguageModelFrequenciesPerDocument << trigramLanguageModelFrequenciesPerDocumentHash
}

# So At This Point, We Have Removed All the Stop Words #
# And We Have Hash Tables for Each Individual Document #
# And for the Overall Set of Documents                 #
# We Now Print Out a CSV File Which Can Be Read Into   #
# Microsoft Excel for Analytical Purposes              #
outputOfTriGramModelFileName = "OutputOfTriGramModel.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfTriGramModelFile = File.open(outputOfTriGramModelFileName, 'w')
outputOfTriGramModelFile.print "Tri-Gram Phrase,Frequency Count\n"

# Now We Can Print Out the Hash Table of All the Documents      #
# To the CSV File for Analysis, We Could Also Print Out the     #
# Hash Table for Each Individual Document, But We Don't For Now #
trigramLanguageModelTotalFrequenciesOfPhrases.sort{
  |a, b|

  # We Sort the List of Bi-Grams From High Frequency to Low Frequency #
  b[1] <=> a[1]
}.each{
  |trigramPhrase|

  # For Each Bi-Gram Phrase, We Just Output It and Its Frequency to the File #
  outputOfTriGramModelFile.print "#{trigramPhrase[0]},#{trigramPhrase[1]}\n"
}

# Now We Appropriately Close the File for Writing for Safety Reasons #
outputOfTriGramModelFile.close

##################################################################
# End of Step 6: Create a Tri-Gram Model from the Language Model #
##################################################################

######################################
# Step 7: Analyze the Uni-Gram Model #
######################################

# First, In Order to Analyze the Uni-Gram Model      #
# We Need to Determine the Number of Uni-Grams       #
# In Each Document and the Total Number of Uni-Grams #
# First, We Calculate the Total Number of Uni-Grams  #
totalNumberOfUniGramsAcrossAllDocuments = 0.0

# In Order to Calculate the Total Number of Uni-Grams  #
# We Loop Over the Hash Table Containing All Uni-Grams #
# And Their Frequencies and Add All the Frequencies    #
unigramLanguageModelTotalFrequenciesOfWords.sort{
  |a, b|

  # We Sort the Hash Table of the Uni-Grams Based on the Frequency #
  b[1] <=> a[1]
}.each{
  |unigram|

  # We Simply Add the Frequency of Each Uni-Gram to the Running Count of All Uni-Grams #
  totalNumberOfUniGramsAcrossAllDocuments = totalNumberOfUniGramsAcrossAllDocuments + unigram[1]
}

# Next, We Would Like to Find the Total Number of Uni-Grams   #
# In Each Document, Which Would Be Useful for Analysis        #
# We Create a Hash Table Where the Key is the Document Numebr #
totalNumberOfUniGramsInEachDocument = Hash.new

# Next, We Loop Through the Array with the Frequencies Per #
# Document and Determine the Total Number of Uni-Grams In  #
# Each Document #
unigramLanguageModelFrequenciesPerDocument.each{
  |trainingfile|

  # We Create a Temporary Variable to Store the Total Number of Words #
  # In Each Document, Which Will Be Stored Into the Hash Table        #
  totalNumberOfUnigramsInCurrentDocument = 0.0

  # We Sort the Document Files #
  trainingfile.sort{
    |a, b|

    # We Sort the Training Files Based on Frequency from Most to Least #
    b[1] <=> a[1]
  }.each{
    |trainingword|

    # We Add the Frequencies of Each Word to a Running Sum of the Total Number of Words #
    totalNumberOfUnigramsInCurrentDocument = totalNumberOfUnigramsInCurrentDocument + trainingword[1]
  }

  # Once We Are Done Collecting All Frequencies of Words for a Given Document #
  # We Store the Values Into the Hash Table, Along With the Document Number   #
  # The Document Number is Just the Index of the Document in the Array        #
  trainingDocumentNumber = unigramLanguageModelFrequenciesPerDocument.index(trainingfile) + 1

  # We Now Store the Data Into the Hash Table #
  if totalNumberOfUniGramsInEachDocument.has_key?(trainingDocumentNumber)

    # We Replace the Value at the Given Key With an Updated Value #
    totalNumberOfUniGramsInEachDocument[trainingDocumentNumber] = totalNumberOfUnigramsInCurrentDocument
  else

    # We Add the New Value for the New Key #
    totalNumberOfUniGramsInEachDocument[trainingDocumentNumber] = totalNumberOfUnigramsInCurrentDocument

  end
}

# Now We Have the Total Number of Uni-Grams In Each Document #
# We Will Print Out This Data To a CSV File So We Can Open   #
# The Data In Excel for Further Analysis of the Data         #
outputOfUniGramsPerDocumentFileName = "OutputOfUniGramsPerDocument.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfUniGramsPerDocumentFile = File.open(outputOfUniGramsPerDocumentFileName, 'w')
outputOfUniGramsPerDocumentFile.print "Document Number,Number of Uni-Grams\n"

# Now We Print Out the Hash Table of All the Documents #
# And Their Total Number of Uni-Grams in Each One      #
totalNumberOfUniGramsInEachDocument.sort{
  |a, b|

  # We Sort the Hash Table Based on the Document Number #
  a[0] <=> b[0]
}.each{
  |trainingfile|

  # We Just Output the Document Number and the Number of Words in the Document #
  outputOfUniGramsPerDocumentFile.print "#{trainingfile[0]},#{trainingfile[1]}\n"
}

# Now We Appropriately Close the File For Writing for Safety Reasons #
outputOfUniGramsPerDocumentFile.close

#############################################
# End of Step 7: Analyze the Uni-Gram Model #
#############################################

#####################################
# Step 8: Analyze the Bi-Gram Model #
#####################################

# First, In Order to Analyze the Bi-Gram Model      #
# We Need to Determine the Number of Bi-Grams       #
# In Each Document and the Total Number of Bi-Grams #
# First, We Calculate the Total Number of Bi-Grams  #
totalNumberOfBiGramsAcrossAllDocuments = 0.0

# In Order to Calculate the Total Number of Bi-Grams  #
# We Loop Over the Hash Table Containing All Bi-Grams #
# And Their Frequencies and Add All the Frequencies    #
bigramLanguageModelTotalFrequenciesOfPhrases.sort{
  |a, b|

  # We Sort the Hash Table of the Bi-Grams Based on the Frequency #
  b[1] <=> a[1]
}.each{
  |bigram|

  # We Simply Add the Frequency of Each Bi-Gram to the Running Count of All Bi-Grams #
  totalNumberOfBiGramsAcrossAllDocuments = totalNumberOfBiGramsAcrossAllDocuments + bigram[1]
}

# Next, We Would Like to Find the Total Number of Bi-Grams    #
# In Each Document, Which Would Be Useful for Analysis        #
# We Create a Hash Table Where the Key is the Document Numebr #
totalNumberOfBiGramsInEachDocument = Hash.new

# Next, We Loop Through the Array with the Frequencies Per #
# Document and Determine the Total Number of Bi-Grams In   #
# Each Document #
bigramLanguageModelFrequenciesPerDocument.each{
  |trainingfile|

  # We Create a Temporary Variable to Store the Total Number of Words #
  # In Each Document, Which Will Be Stored Into the Hash Table        #
  totalNumberOfBigramsInCurrentDocument = 0.0

  # We Sort the Document Files #
  trainingfile.sort{
    |a, b|

    # We Sort the Training Files Based on Frequency from Most to Least #
    b[1] <=> a[1]
  }.each{
    |trainingword|

    # We Add the Frequencies of Each Word to a Running Sum of the Total Number of Words #
    totalNumberOfBigramsInCurrentDocument = totalNumberOfBigramsInCurrentDocument + trainingword[1]
  }

  # Once We Are Done Collecting All Frequencies of Words for a Given Document #
  # We Store the Values Into the Hash Table, Along With the Document Number   #
  # The Document Number is Just the Index of the Document in the Array        #
  trainingDocumentNumber = bigramLanguageModelFrequenciesPerDocument.index(trainingfile) + 1

  # We Now Store the Data Into the Hash Table #
  if totalNumberOfBiGramsInEachDocument.has_key?(trainingDocumentNumber)

    # We Replace the Value at the Given Key With an Updated Value #
    totalNumberOfBiGramsInEachDocument[trainingDocumentNumber] = totalNumberOfBigramsInCurrentDocument
  else

    # We Add the New Value for the New Key #
    totalNumberOfBiGramsInEachDocument[trainingDocumentNumber] = totalNumberOfBigramsInCurrentDocument

  end
}

# Now We Have the Total Number of Bi-Grams In Each Document #
# We Will Print Out This Data To a CSV File So We Can Open  #
# The Data In Excel for Further Analysis of the Data        #
outputOfBiGramsPerDocumentFileName = "OutputOfBiGramsPerDocument.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfBiGramsPerDocumentFile = File.open(outputOfBiGramsPerDocumentFileName, 'w')
outputOfBiGramsPerDocumentFile.print "Document Number,Number of Bi-Grams\n"

# Now We Print Out the Hash Table of All the Documents #
# And Their Total Number of Bi-Grams in Each One       #
totalNumberOfBiGramsInEachDocument.sort{
  |a, b|

  # We Sort the Hash Table Based on the Document Number #
  a[0] <=> b[0]
}.each{
  |trainingfile|

  # We Just Output the Document Number and the Number of Words in the Document #
  outputOfBiGramsPerDocumentFile.print "#{trainingfile[0]},#{trainingfile[1]}\n"
}

# Now We Appropriately Close the File For Writing for Safety Reasons #
outputOfBiGramsPerDocumentFile.close

############################################
# End of Step 8: Analyze the Bi-Gram Model #
############################################

#####################################
# Step 9: Analyze the Tri-Gram Model #
#####################################

# First, In Order to Analyze the Tri-Gram Model      #
# We Need to Determine the Number of Tri-Grams       #
# In Each Document and the Total Number of Tri-Grams #
# First, We Calculate the Total Number of Tri-Grams  #
totalNumberOfTriGramsAcrossAllDocuments = 0.0

# In Order to Calculate the Total Number of Tri-Grams  #
# We Loop Over the Hash Table Containing All Tri-Grams #
# And Their Frequencies and Add All the Frequencies    #
trigramLanguageModelTotalFrequenciesOfPhrases.sort{
  |a, b|

  # We Sort the Hash Table of the Tri-Grams Based on the Frequency #
  b[1] <=> a[1]
}.each{
  |trigram|

  # We Simply Add the Frequency of Each Tri-Gram to the Running Count of All Tri-Grams #
  totalNumberOfTriGramsAcrossAllDocuments = totalNumberOfTriGramsAcrossAllDocuments + trigram[1]
}

# Next, We Would Like to Find the Total Number of Tri-Grams   #
# In Each Document, Which Would Be Useful for Analysis        #
# We Create a Hash Table Where the Key is the Document Numebr #
totalNumberOfTriGramsInEachDocument = Hash.new

# Next, We Loop Through the Array with the Frequencies Per #
# Document and Determine the Total Number of Tri-Grams In  #
# Each Document #
trigramLanguageModelFrequenciesPerDocument.each{
  |trainingfile|

  # We Create a Temporary Variable to Store the Total Number of Words #
  # In Each Document, Which Will Be Stored Into the Hash Table        #
  totalNumberOfTrigramsInCurrentDocument = 0.0

  # We Sort the Document Files #
  trainingfile.sort{
    |a, b|

    # We Sort the Training Files Based on Frequency from Most to Least #
    b[1] <=> a[1]
  }.each{
    |trainingword|

    # We Add the Frequencies of Each Word to a Running Sum of the Total Number of Words #
    totalNumberOfTrigramsInCurrentDocument = totalNumberOfTrigramsInCurrentDocument + trainingword[1]
  }

  # Once We Are Done Collecting All Frequencies of Words for a Given Document #
  # We Store the Values Into the Hash Table, Along With the Document Number   #
  # The Document Number is Just the Index of the Document in the Array        #
  trainingDocumentNumber = trigramLanguageModelFrequenciesPerDocument.index(trainingfile) + 1

  # We Now Store the Data Into the Hash Table #
  if totalNumberOfTriGramsInEachDocument.has_key?(trainingDocumentNumber)

    # We Replace the Value at the Given Key With an Updated Value #
    totalNumberOfTriGramsInEachDocument[trainingDocumentNumber] = totalNumberOfTrigramsInCurrentDocument
  else

    # We Add the New Value for the New Key #
    totalNumberOfTriGramsInEachDocument[trainingDocumentNumber] = totalNumberOfTrigramsInCurrentDocument

  end
}

# Now We Have the Total Number of Tri-Grams In Each Document #
# We Will Print Out This Data To a CSV File So We Can Open   #
# The Data In Excel for Further Analysis of the Data         #
outputOfTriGramsPerDocumentFileName = "OutputOfTriGramsPerDocument.csv"

# Then We Open the File for Writing To and Writing Over #
outputOfTriGramsPerDocumentFile = File.open(outputOfTriGramsPerDocumentFileName, 'w')
outputOfTriGramsPerDocumentFile.print "Document Number,Number of Tri-Grams\n"

# Now We Print Out the Hash Table of All the Documents #
# And Their Total Number of Tri-Grams in Each One      #
totalNumberOfTriGramsInEachDocument.sort{
  |a, b|

  # We Sort the Hash Table Based on the Document Number #
  a[0] <=> b[0]
}.each{
  |trainingfile|

  # We Just Output the Document Number and the Number of Words in the Document #
  outputOfTriGramsPerDocumentFile.print "#{trainingfile[0]},#{trainingfile[1]}\n"
}

# Now We Appropriately Close the File For Writing for Safety Reasons #
outputOfTriGramsPerDocumentFile.close

#############################################
# End of Step 9: Analyze the Tri-Gram Model #
#############################################

#####################################
# Here We Output Data To the Screen #
#####################################

print "-----------------\n"
print "Uni-Gram Analysis\n"
print "-----------------\n"
print "\n"
print "Total Number of Uni-Grams Across All Documents: "
print "#{totalNumberOfUniGramsAcrossAllDocuments}"
print "\n"
print "Total Number of Unique Uni-Grams Across All Documents: "
print unigramLanguageModelTotalFrequenciesOfWords.length
print "\n"

print "\n"

print "----------------\n"
print "Bi-Gram Analysis\n"
print "----------------\n"
print "\n"
print "Total Number of Bi-Grams Across All Documents: "
print "#{totalNumberOfBiGramsAcrossAllDocuments}"
print "\n"
print "Total Number of Unique Bi-Grams Across All Documents: "
print bigramLanguageModelTotalFrequenciesOfPhrases.length
print "\n"

print "\n"

print "-----------------\n"
print "Tri-Gram Analysis\n"
print "-----------------\n"
print "\n"
print "Total Number of Tri-Grams Across All Documents: "
print "#{totalNumberOfTriGramsAcrossAllDocuments}"
print "\n"
print "Total Number of Unique Tri-Grams Across All Documents: "
print trigramLanguageModelTotalFrequenciesOfPhrases.length
print "\n"