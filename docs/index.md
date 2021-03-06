# @Home HRI

## Abstract

Roborregos is the official robotics team of Tec de Monterrey, Monterrey campus. The @Home project consists of the development of a service robot for the home. An HRI (Human Robot Interaction) system allows the operators and developers of the robot to interact with it, both by providing manual inputs and receiving feedback. The purpose of this project is to develop an HRI that allows close introspection of the current @Home robot’s sub-systems and good architecture modularity in case sub-systems are added or modified in the future.

## Introduction

The term robot has been around for a long time and even though the definition applies to both physical things and abstract mechanisms that exist only in software, the general public associates the word robot with a machine, and generally, it is also associated with an industrial setting. This might have been true in the past but with the massive adoption of innovation by the public and the rapid technology advancements of the recent decades, the technologies that have made robots useful for the industry are being applied to commercial and residential use cases.

The International Organization for Standardization (ISO) defines “service robots” as “robots that perform useful tasks for humans or equipment, but not for industrial automation applications”. Service robots are very useful when you want to guarantee consistency in a task that involves humans. Humans can react to external factors in many different ways and consistency is hard to achieve, this is especially true in mundane jobs that are highly repetitive (Karunasena et al, 2021.).

As robots moved from an industrial setting to performing tasks that are useful to humans, a necessity arose to include social interaction capabilities. If a robot cannot be accepted and be proficient in social scenarios it would be really difficult for them to be useful in applications involving humans. Humans are used to heads being the focal point when interacting with other humans, thus it is expected from robots to possess a responsive social interface to act as this focal point (McGinn, 2019).

This project aims to create that interaction focal point while at the same time providing all the features necessary to monitor the robot during contests and development/debugging.


## Development

The current version of the @Home software is developed using ROS as an overarching framework and both C++ and Python as languages for the individual subsystems. As previously stated, the HRI interface must be able to have deep introspection of the robot subsystems, this means that at least one of the components must run within the ROS environment or have access to the streams of information generated in it. As we’ll see in the next section, this requirement led us to divide the HRI subsystem in several independent parts and deal with the challenges that this brought.

### System Architecture

The system is composed of 3 independent components: An interface developed as a web application, a web server from which the interface retrieves the information to show and finally a ROS node that collects the data from the other subsystems and acts as a database for the web server. Figure 1 shows a high level overview of this architecture and how the communication between them is performed.

There’s two main communication scenarios that are showcased with the arrows: from any of the submodules of the robot to the HRI interface, or from the interface to one of the submodules. For the first case, the interface receives each and every message through the use of web sockets, for the second case, the interface sends messages through standard HTTP requests. In any of the two scenarios, the web server establishes communication with the HRI ROS node through the use of Listener and Client primitives that are implemented in the multiprocessing standard Python library, this provides process-to-process communication with built-in serialization using TCP/IP as the underlying protocols. The communications between the HRI ROS node and any other nodes that host different subsystems is done through ROS primitives, meaning using standard or custom ROS messages and by publishing to predefined topics.

<div class="text-center" id="img_1">
  <img alt="Main UI view" class="text-center mb-2" src="images/system.png">
  <p class="small">Figure 1. High level HRI system architecture</p class="small">
</div>

The reason why the web app interface has to be separate from the other components is fairly obvious, the fact that it is built with a library meant to create SPAs (Single Page Applications) means that it’s supposed to be served independently from the API. However, this does not explain why the web server (the API) has to be a separate process from the ROS node.

Both of the components that were just mentioned were written in Python because of its ease of use and our previous familiarity with the language; Python is an interpreted language with dynamic typing which comes with its own set of pros and cons. An interpreted language, as opposed to a compiled language, is not directly executed by the CPU, instead it is either converted to an intermediate representation or kept the same, but in both cases it is executed by an interpreter which is also sometimes called a VM (virtual machine). With all of this said, the root cause of the separation is a mechanism of the Python interpreter called GIL (Global Interpreter Lock) which only allows the code of one thread to be executed concurrently; If ROS and Flask (the framework used to develop the web server) used the same concurrency model it probably wouldn’t have been a problem. However, ROS uses multithreading for concurrency while Flask and almost all other web frameworks for Python use an event loop; these models clash and thus have to be isolated in different processes.

### Web application interface

The interface is to be run in one of the computers that forms the robot’s computing cluster, most likely running linux; any technology that allows building user interfaces and communication with a web server could suffice. We went with web technologies because of its portability which would allow us to run it in any other machine should it or its operating system change in the future; specifically, we opted to use ReactJS because of its simplicity and wide adoption in the community.

Figure 2 shows the main and only page of the interface which is divided into different and independent UI modules. Each module is responsible for receiving information from the web server and displaying it when new updates are available. Each module occupies a flexible amount of screen size and is placed on a flowing grid that allows an arbitrary number of elements to be placed comfortably on the available space.

<div class="text-center" id="img_2">
  <img alt="Main UI view" class="text-center mb-2" src="images/ui_2.png">
  <p class="small">Figure 2. Interface with all the current modules active.</p class="small">
</div>

The current modules and their corresponding functionalities are listed in the table below. It is worth noting that the ability to easily add future modules is one of the core principles that guided the design of this system, meaning this table should grow easily as the needs of the operators and/or developers change.

| Name                 | Functionality                                                                                                                                                    | Communication direction    |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| Robot Face           | Emotionally reflect the actions that the robot is performing.                                                                                                    | From ROS to the interface. |
| Video feed           | Show a direct or manipulated (labels, bounding boxes, etc.) feed of video.                                                                                       | From ROS to the interface. |
| System health        | Show the system status of the computing unit in the cluster that is running the interface. This could be extended to show the status of all the computing units. | From ROS to the interface. |
| Active robot modules | Show which of the robot modules are currently doing processing.                                                                                                  | From ROS to the interface. |
| Robot Chat           | Show a log of the text-to-speech messages the robot has emitted. Send custom commands bypassing the speech-to-text module.                                       | Both ways.                 |
| Stop button          | Send a signal to the robot in case a manual stop is required.                                                                                                    | From the Interface to ROS. |
<div class="text-center" id="img_3">
  <p class="small">Table 1. UI modules of the HRI interface..</p class="small">
</div>

<div class="text-center" id="img_3">
  <img alt="Main UI view" class="text-center mb-2" src="images/configuration_drawer.png">
  <p class="small">Figure 3. Interface drawer.</p class="small">
</div>

Table 1 shows all the available modules and while all of them can certainly be on the screen at the same time, there’s no need to have them all; figure 3 shows the system drawer that slides open when the bottom right button shown in figure 2 is pressed. The drawer allows you to select the modules that you wish to see on the main screen as well as creating new profiles or selecting existing ones; a profile is a locally saved configuration that groups several modules together, meaning, when a profile is selected all the modules it groups are shown on the interface while the ones it doesn’t group are hidden.

<div class="text-center" id="img_4">
  <img alt="Main UI view" class="text-center mb-2" src="images/configuration_selection.png">
  <p class="small">Figure 4. Profile selection UI.</p class="small">
</div>

Figure 4 shows the UI that can be used to select one of the existing profiles; the interaction is really simple, the dropdown is clicked and when the profile is selected, only the UI modules corresponding to it are shown. When the Add config button is clicked, the modal shown in figure 5 is shown.

<div class="text-center" id="img_5">
  <img alt="Main UI view" class="text-center mb-2" src="images/create_configuration.png">
  <p class="small">Figure 5. Profile creation UI.</p class="small">
</div>

The process to create a profile is very simple: First a name is chosen and then the modules that the profile is going to group  must be selected, all or none modules can be selected without any limitations.

### Web server

As mentioned previously, the web server is written in python and uses Flask as the framework of choice. It has a direct connection with the ROS node which can be observed in figure 6.

<!-- Figure 6 -->
```python
# Full duplex connection with the HRI ros node.
receiver_address = ('localhost', 7000)
sender_address = ('localhost', 7001)
```
<div class="text-center" id="img_6">
  <p class="small">Figure 6. Variables definition for full duplex communication from the server side.</p class="small">
</div>

To establish a full duplex (or bidirectional) communication with the ros node we have to have both a sender and a receiver and that’s precisely what is showcased in figure 6. The port used for the ROS receiver is 7000 while the port for the sender is 7001, both of these are ports in the local network, meaning in the same compute unit of the robot’s cluster.

Table 1 also shows that the stop button requires communication from the interface to the ROS subsystems and for this, the communication has to go through the web server in which HTTP is used. Figure 7 shows the route definition that provides the stop functionality. The interface sends a post request to the /stop endpoint and the web server uses the sender (which previously went through an initialization process) to tell the ros node to shut itself down.

<!-- Figure 7 -->
```python
@app.route("/stop", methods=["POST"])
def stop_robot():
    global ros_sender
    ros_sender.send("shutdown")
    return jsonify({"message": "Robot was shutdown"})
```
<div class="text-center" id="img_7">
  <p class="small">Figure 7. Endpoint definition for the stop button.
</p class="small">
</div>

The other purpose of the web server is message forwarding in the opposite direction, meaning from the ROS subsystems to the interface. This is a well defined task that is performed in the function ros_receive_handler which is showcased in figure 8; the function runs as a task that is dispatched to the event loop (the concurrency models were explained previously). Since the ROS receiver is not initialized immediately, there’s a mechanism against lockup that allows all events running in the loop to progress. The important part of this definition is the else clause of the inner if statement: Whenever the web server receives a message from the ROS node, it analyzes is content and in particular, when a certain format is followed, the web socket channel and the value to be sent are extracted and then emitted through the socket itself.

<!-- Figure 8 -->
```python
# Decode messages and send them to the appropriate socket channel.
def ros_receive_handler():
    while True:
        if ros_receiver is None:
            # Avoid blocking the process before initialization.
            socketio.sleep(0.01)
            continue
        # Only call `recv` when we're sure there's a new message since
        # it is a blocking call.
        if ros_receiver.poll():
            try:
                message = ros_receiver.recv()
            except:
                # Ignore message if there was an exception.
                # TODO: We should not do this becuase we could
                # loose critical messages.
                rospy.loginfo("There was an exception")
                continue

            if message == "CreateSender":
                initialize_ros_sender()
            elif message == "Close":
                cleanup()
            else:
                channel = message["channel"]
                value = message["value"]
                socketio.emit(
                    channel,
                    value if type(value) == str else json.dumps(value)
                )
        else:
            # Only throttle if there are no available messages.
            socketio.sleep(0.01)
```
<div class="text-center" id="img_8">
  <p class="small">Figure 8. Definition of the event forwarding mechanism. 
</p class="small">
</div>

### ROS Node

As previously mentioned, the role of the ROS node is to compile the information coming from the subsystems and make it easily available to the interface through the web server. In this node we also need the implementation of the full duplex communication; figure 9 shows that the definition is exactly the same, as are the ports to be used, the difference is that from the ROS side, the ports are interchanged: Port 7000 for the server is the receiver while in ROS is the sender; port 7001 for the server is the sender while in ROS is the receiver.

<!-- Figure 9 -->
```python
# Implement a full duplex connection with the flask server.
sender_address = ('localhost', 7000)
receiver_address = ('localhost', 7001)
```
<div class="text-center" id="img_9">
  <p class="small">Figure 9. Variables definition for full duplex communication from the ROS side.
</p class="small">
</div>

Similar to the server process, the ROS node has a message handler for anything that’s coming from the web server that needs to be handled; for the current implementation, the only event that is handled by ROS coming from the server is shutdown. The implementation for this handler is shown in figure 10, as opposed to the server, the concurrency model in ROS is multithreaded and thus, flask_receive_handler is scheduled as a thread.

<!-- Figure 10 -->
```python
def flask_receive_handler():
    while True:
        if server_receiver is None:
            # Don't block execution.
            time.sleep(0.01)
            continue
        if server_receiver.poll():
            try:
                message = server_receiver.recv()
                if message == "shutdown":
                    rospy.loginfo("Stopping system")
                rospy.loginfo(message)
            except:
                break
        # Don't block execution.
        time.sleep(.01)
```
<div class="text-center" id="img_10">
  <p class="small">Figure 10. Message handler definition for messages going from the server to ROS.</p class="small">
</div>

The types of messages that the interface currently handles could be classified in two: Robot status and video feed. The video feed is easily represented by a series of Image ROS messages; the definition for such messages is exported by the sensor_msgs package which is widely used by the community. In the case of robot status we created a custom message that encodes all the information needed by the interface (other than images), this definition is shown in figure 11.

<!-- Figure 11 -->
```
Header header
string[] ActionQueue
float32[3] SystemHealth
string RobotStatus
string[] ActiveModules
string RobotMessage
string RobotFace
```
<div class="text-center" id="img_11">
  <p class="small">Figure 11. Definition for the RobotStatus custom message.</p class="small">
</div>

As it has been previously mentioned, other than from the server, the ROS node must receive messages from several robot subsystems, and this is done differently for the two discussed cases (status or video). Figure 12 shows how the messages regarding status are handled, which if we analyze it carefully, is a simple forward: We extract the information from the RobotStatus message and send it to the web server. This function is used as the callback of a ROS subscription for the /robo_info topic, which internally is launched as a separate thread.


```python
def robot_info_receive_handler(robot_status):
    if server_sender is not None:
        for channel in channels:
            try:
                server_sender.send({
                    "channel": channel,
                    "value": getattr(robot_status, channel)
                })
            except:
                print("Error fetching: ", channel)


...

channels = [
    "ActionQueue",
    "SystemHealth",
    "RobotStatus",
    "ActiveModules",
    "RobotMessage",
    "RobotFace"
]

```
<!-- Figure 12 -->
<div class="text-center" id="img_12">
  <p class="small">Figure 12. Message handler for robot status</p class="small">
</div>

The process for the camera feed is very similar, in this case the topic used is /robot_video_feed but there’s some data transformation required before being forwarded to the server, all of this is showcased in figure 13. Originally, the stream arrives as Image messages but has to be encoded as base64; any and all messages sent to the interface through the web sockets must be in string form, either JSON encoded or as plain string data. Base 64 was chosen because browsers support it directly, that is to say, if we can send images as base64 encoded binaries, the browser that is rendering the interface can show them without any conversion. Luckily, OpenCV (which is already used in the robot) has built-in functions to obtain the binary value of an image which can in turn be encoded using Python standard libraries.

<!-- Figure 13 -->
```python
def robot_video_feed_receive_handler(image_msg):
    if server_sender is not None:
        img = bridge.imgmsg_to_cv2(image_msg, desired_encoding="passthrough")
        _, img_buffer = cv2.imencode('.jpg', img)
        img_text = base64.b64encode(img_buffer)
        server_sender.send({
            "channel": "CameraFeed",
            "value": img_text.decode("ascii")
        })
```
<div class="text-center" id="img_13">
  <p class="small">Figure 13. Message handler for the camera feed.
</p class="small">
</div>


## Future work

The present work has shown the architecture and implementation of an interface that serves as a proof of concept that such systems can be built and also as a first functional implementation, this because most of the requirements of the development team were met, at least referring to the interface. The future work for the HRI system is very clear: Integrate the interface with the ROS subsystems that can make use of it, specifically, create internal tasks in the nodes so they can send information they see fit to either the /robot_inf or /robot_video_feed topics.

Additionally, new UI modules can be added to the interface as needs arise. However, this requires a complete process involving all 3 of the modules. Future iterations of the interface could make the process to add modules easier or even automated through manual scripts or code generation techniques.

## Conclusion

We believe that the way in which we interact with technology and in this case, how we interact with robots, will be a very big research and development area in the future. Although there are multiple classes of robots that can benefit from a better or more robust interaction, the service robot category will certainly receive more attention since there’s still a lot to improve. The purpose of this project was to prove that these types of systems can be built with current technology, for the case of the @Home robot this meant using ROS, Python and web technologies. With a few hiccups along the way, we ended up with a functional first version that paves the way for future development by the end users themselves (the Roborregos team). While the work performed here showcases a very small part of the problems to be solved in this discipline (integration of current technologies), it sets the precedents for future development and showcases the importance of having a system of such kind.

## References

Karunasena, Ramesha et al. “DEVI: Open-Source Human-Robot Interface for Interactive Receptionist Systems.” 2019 IEEE 4th International Conference on Advanced Robotics and Mechatronics (ICARM) (2019): n. pag. Crossref. Web.

McGinn, Conor. “Why Do Robots Need a Head? The Role of Social Interfaces on Service Robots.” International Journal of Social Robotics, vol. 12, no. 1, 2020, p. 281. EBSCOhost, doi:10.1007/s12369-019-00564-5.

Iocchi, L. (. 1. )., et al. “RoboCup@Home: Analysis and Results of Evolving Competitions for Domestic and Service Robots.” Artificial Intelligence, vol. 229, pp. 258–281. EBSCOhost, doi:10.1016/j.artint.2015.08.002. Accessed 10 June 2021.

Stalljann, Sarah et al. “Performance Analysis of a Head and Eye Motion-Based Control Interface for Assistive Robots.” Sensors 20.24 (2020): 7162. Crossref. Web.

Chen, Mingxuan, et al. “A Human–robot Interface for Mobile Manipulator.” Intelligent Service Robotics, vol. 11, no. 3, 2018, p. 269. EBSCOhost, doi:10.1007/s11370-018-0251-3.
