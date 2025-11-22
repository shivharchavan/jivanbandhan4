<%@ Page Title="जिवनबंधन - मराठी मॅट्रिमोनी" Language="C#" MasterPageFile="MasterPage.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JivanBandhan.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        body {
            background: linear-gradient(rgba(255,255,255,0.9), rgba(255,255,255,0.9)), 
                        url('/Images/maharashtrian-couple-bg.jpg') center/cover no-repeat fixed;
            font-family: 'Noto Sans Devanagari', 'Nirmala UI', sans-serif;
            min-height: 100vh;
        }

        .main-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.3);
            margin: 40px auto;
            padding: 40px;
        }

        .hero-title {
            color: #e74c3c;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            margin-bottom: 20px;
        }

        .tagline {
            color: #2c3e50;
            font-size: 1.4rem;
            margin-bottom: 30px;
        }

        .feature-card {
            transition: transform 0.3s;
            border-radius: 15px;
            border: none;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            height: 100%;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .feature-card-2 {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .feature-card-3 {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .feature-card-4 {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .success-story-card {
            transition: transform 0.3s;
            border: none;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            height: 100%;
            border-radius: 15px;
            overflow: hidden;
        }

        .success-story-card:hover {
            transform: scale(1.05);
        }

        .btn-custom {
            border-radius: 50px;
            padding: 15px 40px;
            font-weight: 700;
            font-size: 18px;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .btn-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .icon-large {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            opacity: 0.9;
        }

        .marathi-font {
            font-family: 'Noto Sans Devanagari', 'Nirmala UI', sans-serif;
            font-weight: 600;
        }

        .section-title {
            color: #2c3e50;
            font-weight: 700;
            margin-bottom: 3rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 100px;
            height: 5px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 15px auto;
            border-radius: 10px;
        }

        .stats-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 40px;
            margin: 50px 0;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .cta-section {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            border-radius: 20px;
            padding: 50px;
            margin-top: 50px;
        }
    </style>
<%--</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">--%>
    <div class="container">
        <div class="main-container">
            <!-- Main Header -->
            <div class="text-center mb-5">
                <h1 class="hero-title marathi-font display-2">जिवनबंधन</h1>
                <p class="tagline marathi-font">मराठी संस्कृतीतून जोड्या जुळवणारा विश्वासार्ह साथी</p>
                
                <!-- Quick Action Buttons -->
                <div class="row justify-content-center g-4 mt-4">
                    <div class="col-lg-3 col-md-6">
                        <asp:Button ID="btnFindPartner" runat="server" Text="जोडीदार शोधा" 
                            CssClass="btn btn-primary w-100 btn-custom marathi-font" 
                            PostBackUrl="~/SearchProfiles.aspx" />
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <asp:Button ID="btnRegisterFree" runat="server" Text="विनामूल्य नोंदणी" 
                            CssClass="btn btn-success w-100 btn-custom marathi-font" 
                            PostBackUrl="~/Registrations.aspx" />
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <asp:Button ID="btnLogin" runat="server" Text="लॉगिन" 
                            CssClass="btn btn-info w-100 btn-custom marathi-font" 
                            PostBackUrl="~/Login.aspx" />
                    </div>
                </div>
            </div>

            <!-- Features Section -->
            <section class="py-5">
                <h2 class="text-center section-title marathi-font">आमचे विशेष फीचर्स</h2>
                <div class="row">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="feature-card p-4 text-center">
                            <div class="icon-large">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h4 class="marathi-font">सुरक्षित</h4>
                            <p class="marathi-font">पूर्णतः सत्यापित प्रोफाइल्स</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="feature-card feature-card-2 p-4 text-center">
                            <div class="icon-large">
                                <i class="fas fa-users"></i>
                            </div>
                            <h4 class="marathi-font">विश्वासार्ह</h4>
                            <p class="marathi-font">१०,०००+ यशस्वी जोड्या</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="feature-card feature-card-3 p-4 text-center">
                            <div class="icon-large">
                                <i class="fas fa-heart"></i>
                            </div>
                            <h4 class="marathi-font">मराठी</h4>
                            <p class="marathi-font">मराठी संस्कृतीचा आदर</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="feature-card feature-card-4 p-4 text-center">
                            <div class="icon-large">
                                <i class="fas fa-star"></i>
                            </div>
                            <h4 class="marathi-font">सोपे</h4>
                            <p class="marathi-font">सहज वापर</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Statistics Section -->
            <section class="stats-section">
                <div class="row text-center">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-number">10,000+</div>
                        <div class="stat-label marathi-font">यशस्वी जोड्या</div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-number">50,000+</div>
                        <div class="stat-label marathi-font">नोंदणीकृत सदस्य</div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-number">25+</div>
                        <div class="stat-label marathi-font">शहरे</div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-number">98%</div>
                        <div class="stat-label marathi-font">समाधानी सदस्य</div>
                    </div>
                </div>
            </section>

            <!-- Success Stories -->
            <section class="py-5">
                <h2 class="text-center section-title marathi-font">यशस्वी कहाण्या</h2>
                <div class="row">
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card success-story-card">
                            <img src="/Images/couple1.jpg" class="card-img-top" alt="राजेश आणि प्रियंका" 
                                 style="height: 250px; object-fit: cover;">
                            <div class="card-body text-center">
                                <h5 class="card-title marathi-font">राजेश आणि प्रियंका</h5>
                                <p class="card-text marathi-font">"जिवनबंधन मधून आमची ओळख झाली आणि आता आम्ही आनंदाने जगतो आहोत."</p>
                                <small class="text-muted marathi-font">लग्न: २०२२</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card success-story-card">
                            <img src="/Images/couple2.jpg" class="card-img-top" alt="सागर आणि आशा" 
                                 style="height: 250px; object-fit: cover;">
                            <div class="card-body text-center">
                                <h5 class="card-title marathi-font">सागर आणि आशा</h5>
                                <p class="card-text marathi-font">"मराठी संस्कृती जपणारी जोडी शोधायला जिवनबंधनने मदत केली."</p>
                                <small class="text-muted marathi-font">लग्न: २०२१</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card success-story-card">
                            <img src="/Images/couple3.jpg" class="card-img-top" alt="अमोल आणि संजीवनी" 
                                 style="height: 250px; object-fit: cover;">
                            <div class="card-body text-center">
                                <h5 class="card-title marathi-font">अमोल आणि संजीवनी</h5>
                                <p class="card-text marathi-font">"आमच्या सारख्या व्यस्त जीवनशैलीमध्ये जिवनबंधन खरोखरच उपयुक्त ठरले."</p>
                                <small class="text-muted marathi-font">लग्न: २०२३</small>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- CTA Section -->
            <section class="cta-section text-center">
                <h2 class="mb-4 marathi-font" style="color: #2c3e50; font-weight: 700;">
                    आपल्या जीवनाच्या सफरचंदाचा साथीदार शोधायचा आहे?
                </h2>
                <p class="lead mb-4 marathi-font" style="color: #2c3e50; font-size: 1.3rem;">
                    आजच नोंदणी करा आणि आपला आदर्श जोडीदार शोधा
                </p>
                <asp:Button ID="btnRegisterNow" runat="server" Text="आजच नोंदणी करा" 
                    CssClass="btn btn-danger btn-lg btn-custom marathi-font" 
                    PostBackUrl="~/Register.aspx" />
            </section>
        </div>
    </div>
</asp:Content>