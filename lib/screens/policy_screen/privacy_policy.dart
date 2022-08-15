import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: PRIMARY_BLUE,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: HtmlWidget("""<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Study Pill</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    <style>
        body {
            font-family: 'Nunito', sans-serif;
            margin: 20px 5% 50px 5%;
            width: 90% !important;
        }

        p {
            margin-top: 20px;
        }
        
        h1 {
            margin-top: 20px;
            font-size: 30px;
        }

        h2 {
            margin-top: 20px;
            font-size: 20px;
        }
    </style>
</head>

<body>
    <p><strong>Privacy Policy</strong></p>
    
    <p>StudyPill built the StudyPill app as an Ad Supported app. This SERVICE is provided by StudyPill at no cost and is intended for use as is.</p>
    <p>This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.</p>
    <p>If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.</p>
    <p>The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at StudyPill unless otherwise defined in this Privacy Policy.</p>
    
    
    <p><strong>Consent</strong></p>
    <p>By using our website, you hereby consent to our Privacy Policy and agree to its terms.</p>
    
    
    <p><strong>Information Collection and Use</strong></p>
    <p>For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Full Name, Email Address, Age, location, Gmail authentication, phone number, cookies and usage data. The information that we request will be retained by us and used as described in this privacy policy. Since our administrative site is <a href="http://www.studypill.org">www.studypill.org</a> ,all the information we collect is stored and maintained in it.</p>
    
    <p><strong>Third Party Privacy Policies</strong></p>
    <p>Study Pill's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.</p>
    
    <p>You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites.</p>
    <p>The app does use third-party services that may collect information used to identify you.</p>
    <p>Link to the privacy policy of third-party service providers used by the app</p>
    <ul>
    <li><a href="https://www.google.com/policies/privacy/">Google Play Services</a></li>
    <li><a href="https://support.google.com/admob/answer/6128543?hl=en">AdMob</a></li>
    <li><a href="https://firebase.google.com/policies/analytics">Google Analytics for Firebase</a></li>
    <li><a href="https://firebase.google.com/support/privacy/">Firebase Crashlytics</a></li>
    </ul>
    
    
    <p><strong>Log Data</strong></p>
    
    <p>We want to inform you that whenever you use our Service, in the case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (&ldquo;IP&rdquo;) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.</p>
    
    
    <p><strong>Cookies</strong></p>
    
    <p>Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.</p>
    <p>This Service does not use these &ldquo;cookies&rdquo; explicitly. However, the app may use third-party code and libraries that use &ldquo;cookies&rdquo; to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.</p>
    
    
    <p><strong>Service Providers</strong></p>
    <p>We may employ third-party companies and individuals due to the following reasons:</p>
    <ul>
    <li>To facilitate our Service;</li>
    <li>To provide the Service on our behalf;</li>
    <li>To perform Service-related services; or</li>
    <li>To assist us in analyzing how our Service is used.</li>
    </ul>
    <p>We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.</p>
    
    
    <p><strong>Security</strong></p>
    
    <p>We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.</p>
    
    
    <p><strong>Links to Other Sites</strong></p>
    
    <p>This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.</p>
    
    
    <p><strong>How we use your information</strong></p>
    <p>We use the information we collect in various ways, including to:</p>
    <ul>
    <li>Provide, operate, and maintain our website</li>
    <li>Improve, personalize, and expand our website</li>
    <li>Understand and analyze how you use our website</li>
    <li>Develop new products, services, features, and functionality</li>
    <li>Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes</li>
    <li>Send you emails</li>
    <li>Find and prevent fraud</li>
    <li></li>
    </ul>
    
    
    <p><strong>Children&rsquo;s Privacy</strong></p>
    
    <p>These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.</p>
    
    
    <p><strong>Changes to This Privacy Policy</strong></p>
    
    <p>We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.</p>
    <p>This policy is effective as of 2022-03-16</p>
    
    
    <p><strong>Contact Us</strong></p>
    
    <p>If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at studypill.np@gmail.com.</p>
    
    
    </body></html>""")),
        ),
      ),
    );
  }
}
