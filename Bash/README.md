# Program purpose: Processing the provided text into a bag of words model.
  
  Bag of words is a model that disregards the order of words but counts their occurrences.
Thanks to this, we can determine the general topic of the text and compare it to others.
This model is used in NLP (Natural Language Processing) and IR (Information Retrieval).

  To run the program, use ./bash_simple_bag_of_words.sh 'filename to process', optionally
adding one of the options. It is important that the filename contains the '.txt' extension 
as the program checks whether it will be able to handle the given file based on it.

  Options: The program has two available options: -h/--help which you just used, and -log, which causes
the program to write words and their counts to the file 'filename'_results.txt instead of printing them to the screen.
The program ignores unknown parameters.
 
   The program will inform the user if: they forget to provide a file, provide an incorrect file name, have incorrect
character encoding set, or if the result file for the current file already exists."
