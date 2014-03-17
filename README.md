# MATLAB Spring 2014 – Research Plan (Template)
(text between brackets to be removed)

> * Group Name: Zurich Traffic Group
> * Group participants names: Jan Dörrie, Simone Forte, Charalampos Gkonos, Athina Korfiati  
> * Project Title: Traffic simulation in the city of Zurich

## General Introduction

Traffic is a serious problem with which every city has to deal. In the city of Zurich, traffic is also a problem and the adopted actions aim at a better organisation, which can lead to a better combination of travel safety and efficiency.

## The Model

The progect will be based in general terms on the "Four step model".

The four steps of the classical urban transportation planning system model are:

- Trip generation determines the frequency of origins or destinations of trips in each zone by trip purpose, as a function of land uses and household demographics, and other socio-economic factors.
- Trip distribution matches origins with destinations, often using a gravity model function, equivalent to an entropy maximizing model. Older models include the fratar model.
- Mode choice computes the proportion of trips between each origin and destination that use a particular transportation mode. (This modal model may be of the logit form, developed by Nobel Prize winner Daniel McFadden.)
- Route assignment allocates trips between an origin and destination by a particular mode to a route. Often (for highway route assignment) Wardrop's principle of user equilibrium is applied (equivalent to a Nash equilibrium), wherein each driver (or group) chooses the shortest (travel time) path, subject to every other driver doing the same. The difficulty is that travel times are a function of demand, while demand is a function of travel time, the so-called bi-level problem. Another approach is to use the Stackelberg competition model, where users ("followers") respond to the actions of a "leader", in this case for example a traffic manager. This leader anticipates on the response of the followers.

## Fundamental Questions

The goal is to develop an efficient traffic model based on our data. To implement the model in order to visualise the existing traffic situation in the city of Zurich. Then, we want to analyse the impact that a highway tunnel connecting the two sides of the lake would have in the whole area.

## Expected Results

The expected result would be an amelioration of the traffic situation in the city. More specifically it is expected that the travel time for a driver to move from one place to another will be reduced, while at the same time the amount of traffic jam in the roads will be declined.

## References 

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)

- OpenStreetMap
- http://www.ggau.net/html/GG03.html
- http://www.its.uci.edu/its/publications/papers/CASA/UCI-ITS-AS-WP-07-2.pdf

## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)


## Other

(mention datasets you are going to use)
