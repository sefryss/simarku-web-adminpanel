import 'package:cloud_firestore/cloud_firestore.dart';

class AppDetailModel{

  String? id="";
  String? name="";
  String? adId="";
  String? iosAdId="";
  String? bannerAdId="";
  String? iosBannerAdId="";
  String? interstitialAdId="";
  String? iosInterstitialAdId="";
  String? image="";
  String? terms="";
  String? privacyPolicy="";
  String? aboutUs="";



  AppDetailModel({this.terms,this.privacyPolicy,this.aboutUs,this.iosAdId,this.name,this.adId,this.bannerAdId,this.iosBannerAdId,this.interstitialAdId,this.iosInterstitialAdId,this.image,this.id});

  factory AppDetailModel.fromFirestore(DocumentSnapshot doc) {


    Map data = doc.data() as Map;


    return AppDetailModel(
      id: doc.id,
      name: data['name'] ??'',
      adId: data['adId'] ??'',
      iosAdId: data['iosAdId'] ??'',
      image: data['image']??'',
      bannerAdId: data['bannerAdId']??'',
      iosBannerAdId: data['iosBannerAdId']??'',
      interstitialAdId: data['interstitialAdId']??'',
      iosInterstitialAdId: data['iosInterstitialAdId']??'',
      terms: data['terms']??'',
      privacyPolicy: data['privacyPolicy']??'',
      aboutUs: data['aboutUs']??'',

    );
  }

  factory AppDetailModel.fromJson(Map<String, dynamic> data) {
    return AppDetailModel(
      image: data['image'],
      name: data['name'],
      adId: data['adId'],
      iosAdId: data['iosAdId'],
      bannerAdId: data['bannerAdId'],
      iosBannerAdId: data['iosBannerAdId'],
      interstitialAdId: data['interstitialAdId'],
      iosInterstitialAdId: data['iosInterstitialAdId'],
      terms: data['terms'],
      privacyPolicy: data['privacyPolicy'],
      aboutUs: data['aboutUs'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['adId'] = this.adId;
    data['iosAdId'] = this.iosAdId;
    data['bannerAdId'] = this.bannerAdId;
    data['iosBannerAdId'] = this.iosBannerAdId;
    data['interstitialAdId'] = this.interstitialAdId;
    data['iosInterstitialAdId'] = this.iosInterstitialAdId;
    data['image'] = this.image;
    data['terms'] = this.terms;
    data['privacyPolicy'] = this.privacyPolicy;
    data['aboutUs'] = this.aboutUs;

    return data;
  }


}