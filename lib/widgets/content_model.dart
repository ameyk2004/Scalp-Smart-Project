class OnBoardingContent {
  final String image;
  final String title;
  final String description;

  OnBoardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    image: "https://img.freepik.com/premium-vector/female-doctor-reads-medical-analysis_258386-6.jpg",
    title: 'Analyze Your Scalp Health',
    description: 'Upload a Photo to Assess Baldness Stage',
  ),
  OnBoardingContent(
    image: 'https://static.vecteezy.com/system/resources/previews/006/349/083/original/illustration-graphic-cartoon-character-of-solution-free-vector.jpg',
    title: 'Haircare Solutions',
    description: 'Receive Product Recommendations',
  ),
  OnBoardingContent(
    image: 'https://cdni.iconscout.com/illustration/premium/thumb/student-progress-tracking-3862328-3213880.png',
    title: 'Track Your Progress',
    description: 'Monitor Hair Growth and Improvements',
  ),
];
