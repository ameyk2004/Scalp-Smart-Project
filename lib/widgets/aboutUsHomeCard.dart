import 'package:flutter/material.dart';
import 'package:scalp_smart/widgets/aboutUsDetailsCard.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

class AboutUsHomeCard extends StatelessWidget {
  final String name;
  final String role;
  final int age;
  final String ImageSrc;
  final String description;

  const AboutUsHomeCard({
    super.key, required this.name, required this.role, required this.age, required this.ImageSrc, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsDetailsCard(imageSrc: ImageSrc, description: description, role: role, name: name,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 130,
          color: Colors.grey.shade200,
          child: Row(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageSrc),
                        fit: BoxFit.cover,
                        alignment: Alignment
                            .topCenter, // Align the top of the image within the container
                      ),
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
              ),
              const SizedBox(width: 20,),


              Expanded(
                child: Container(


                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(name,
                          style: AppWidget.boldTextStyle(),),
                        Text("Role : $role",
                          style: const TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,),
                         Text("Age : $age",
                            style: TextStyle(fontSize: 17)),
                         Text("College : PICT, PUNE",
                            style: TextStyle(fontSize: 17)),
                      ],

                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
