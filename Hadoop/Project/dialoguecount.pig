-- Load input file from HDFS
inputDialogues4 = LOAD 'hdfs:///user/apatnala/inputs/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, dialogue:chararray);
inputDialogues5 = LOAD 'hdfs:///user/apatnala/inputs/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, dialogue:chararray);
inputDialogues6 = LOAD 'hdfs:///user/apatnala/inputs/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray, dialogue:chararray);

--Filter first 2 lines
ranked4 = RANK inputDialogues4;
onlyDialogues4 = FILTER ranked4 BY (rank_inputDialogues4 > 2);
ranked5 = RANK inputDialogues5;
onlyDialogues5 = FILTER ranked5 BY (rank_inputDialogues5 > 2);
ranked6 = RANK inputDialogues6;
onlyDialogues6 = FILTER ranked6 BY (rank_inputDialogues6 > 2);

-- Merge the inputs
inputData = UNION onlyDialogues4, onlyDialogues5, onlyDialogues6;

-- Group dialogues by name
grped = GROUP inputData BY name;

--Count dialogues grouped by each name
count = FOREACH grped GENERATE $0 as name, COUNT($1) as number_of_lines;
namesOrder = Order count BY number_of_lines DESC;

-- Remove the outouts folder
rmf hdfs:///user/apatnala/outputs;

--Store the count in a folder
STORE namesOrder INTO 'hdfs:///user/apatnala/outputs' USING PigStorage('\t');
