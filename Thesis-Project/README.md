# Thesis Project

## Abstract

Through this diploma thesis we are attempting an approach to the problem of managing a large volume of data. 
There are a lot of systems where a significant amount of information is involved and they belong to many different situations. 
As an example of a study we chose that of the social networks. 
Social networks in the last decade have become an integral part of the lives of billions of people all around the world.
Therefore, we mainly deal with issues concerning the performance of such a network under heavy load, and we are looking at ways to provide answers. 
To do this, in first place, we design and implement a social networking web application in order to determine the operations 
that such a scenario has to have, and then we try to identify those parts that are unable to respond to the growing load. 
Afterwards, using the capabilities of Apache Spark, which is a programming and computing model for distributed systems, 
we try to address the needs of the network, using specific architectures and methods.
Finally, to ensure the computing resources required by Apache Spark, a computer cluster, 
we transferred our implementation and executed our metrics to Google’s cloud computing service, Google Cloud Platform.

<b>Keywords:</b> Social networks, Big data, Web app, Computer cluster, Apache Spark, NoSQL database, Cloud computing

## Sub-projects

<b>JitterN</b>: A Java twitter clone implemented with Spring Framework and MongoDB.

<b>MongoDB-ops</b>: The operations of a social network.

<b>MongoDB-metrics</b>: Extraction of metrics for every user.

<b>Spark-ops-metrics</b>: Implementation of the most intensive operation of the social network and extraction of metrics using Apache Spark.

<b>TCP-Server</b>: It generates tweets in order to similate the operation of the social network. 

<b>Spark-Streaming</b>: It connects to the TCP server, reads the tweets and then finds the users to whom they have to be delivered.
Finally writes the tweets to users' timelines (represented as textFiles).
