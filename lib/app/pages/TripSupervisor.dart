import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/Drawer.dart';

class TripsupervisorPage extends StatefulWidget {
	static final String routeName = 'Tripsupervisor';

     final List list;

TripsupervisorPage(this.list);

	@override
	State<StatefulWidget> createState() {
		return new _TripsupervisorPageState(list);
	}

}

class _TripsupervisorPageState extends State<TripsupervisorPage> {

        final List list;

_TripsupervisorPageState(this.list);

	@override
	void initState() {
		super.initState();
		
    
	}



	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			//key: _scaffoldKey,
      drawer: new Drawer(child: new DrawerComponent("_username", "_schoolID", int.parse("_role_ID_Level")),),
			appBar: new AppBar(
				title: new Text('Supervisors'),
			),
			body:  new Center(
             child:  new ListView.builder(
                                //key: ,
                                  padding: const EdgeInsets.all(15.0),
                                  itemCount: list.length,
                                  itemBuilder: (BuildContext context, int position){

                                    if(position.isOdd)return new Divider(
                                      color: Colors.red,
                                    );
                                    final index = position ~/2;

                                    return new ListTile(
                                      title: new Text("Supervisor: ${list[index]['Name']}",
                                          style: new TextStyle(
                                              fontSize: 18.9,
                                              fontWeight: FontWeight.bold)),

                                      subtitle: new Text("Phone: ${list[index]['Phone']}",
                                          style: new TextStyle(
                                              fontSize: 13.4,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic)),

                                    );


                                  }
                              ),


      
            
          ),

		);
	}



}