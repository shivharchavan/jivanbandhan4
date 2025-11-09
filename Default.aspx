<%@ Page Title="Marathi Matrimony - Find Your Perfect Match" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JivanBandhan4.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero-section {
            background: linear-gradient(135deg, rgba(214, 51, 132, 0.9) 0%, rgba(139, 0, 0, 0.9) 100%), url('Images/hero-bg.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        
        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
            border: 1px solid #e9ecef;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #d63384 0%, #8b0000 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            margin: 0 auto 20px;
        }
        
        .stats-section {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            padding: 80px 0;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: #d63384;
            display: block;
        }
        
        .quick-search {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            margin-top: -50px;
            position: relative;
            z-index: 10;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8 mx-auto">
                    <h1 class="display-4 fw-bold marathi-font mb-4">आपला आदर्श जोडीदार शोधा</h1>
                    <p class="lead marathi-font mb-5">विश्वास, सुरक्षितता आणि समर्पण यावर भर देणारा मराठी समुदायातील अग्रगण्य विवाह संस्था</p>
                    
                    <div class="row g-3 justify-content-center">
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlLookingFor" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Value="">-- शोधत आहे --</asp:ListItem>
                                <asp:ListItem Value="पुरुष">वर</asp:ListItem>
                                <asp:ListItem Value="स्त्री">वधू</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlReligion" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Value="">-- धर्म --</asp:ListItem>
                                <asp:ListItem Value="हिंदू">हिंदू</asp:ListItem>
                                <asp:ListItem Value="बौद्ध">बौद्ध</asp:ListItem>
                                <asp:ListItem Value="जैन">जैन</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlAge" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Value="">-- वय --</asp:ListItem>
                                <asp:ListItem Value="18-25">18-25</asp:ListItem>
                                <asp:ListItem Value="26-30">26-30</asp:ListItem>
                                <asp:ListItem Value="31-35">31-35</asp:ListItem>
                                <asp:ListItem Value="36-40">36-40</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 शोधा" 
                                CssClass="btn btn-light btn-lg w-100 marathi-font fw-bold" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <asp:LinkButton ID="btnAdvancedSearch" runat="server" CssClass="text-white marathi-font" PostBackUrl="~/BrowseProfiles.aspx">
                            🎯 प्रगत शोध सुरू करा
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Search Section -->
    <div class="container">
        <div class="quick-search">
            <h3 class="text-center marathi-font mb-4">⚡ द्रुत शोध</h3>
            <div class="row g-3">
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?gender=स्त्री&religion=हिंदू" class="btn btn-outline-primary w-100 marathi-font">हिंदू वर</a>
                </div>
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?gender=पुरुष&religion=हिंदू" class="btn btn-outline-primary w-100 marathi-font">हिंदू वधू</a>
                </div>
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?religion=बौद्ध" class="btn btn-outline-primary w-100 marathi-font">बौद्ध</a>
                </div>
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?religion=जैन" class="btn btn-outline-primary w-100 marathi-font">जैन</a>
                </div>
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?education=डॉक्टर" class="btn btn-outline-primary w-100 marathi-font">डॉक्टर</a>
                </div>
                <div class="col-md-2 col-6">
                    <a href="BrowseProfiles.aspx?education=इंजिनियर" class="btn btn-outline-primary w-100 marathi-font">इंजिनियर</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="marathi-font">🎯 आमची विशेष वैशिष्ट्ये</h2>
                <p class="lead marathi-font">विश्वासार्ह आणि सुरक्षित पद्धतीने आपला जोडीदार शोधा</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h4 class="marathi-font">🔒 सुरक्षित प्रोफाइल</h4>
                        <p class="marathi-font">सर्व प्रोफाइल सत्यापित आणि सुरक्षित. आपली व्यक्तिगत माहिती गोपनीय राहील.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h4 class="marathi-font">🔍 सविस्तर शोध</h4>
                        <p class="marathi-font">वय, शिक्षण, व्यवसाय, कुटुंब स्थिती इ. ५०पेक्षा जास्त निकषांवर शोधा.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <h4 class="marathi-font">💝 योग्य जुळणी</h4>
                        <p class="marathi-font">आमच्या आधुनिक अल्गोरिदमद्वारे तुमच्यासाठी योग्य जोडीदार शोधा.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h4 class="marathi-font">📱 मोबाइल फ्रेंडली</h4>
                        <p class="marathi-font">सर्व डिव्हाइसवर काम करणारी आधुनिक आणि वापरायला सोपी वेबसाइट.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h4 class="marathi-font">📞 २४x७ समर्थन</h4>
                        <p class="marathi-font">आमची सहाय्यता टीम तुम्हाला कोणत्याही वेळी मदत करण्यासाठी तयार आहे.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-rupee-sign"></i>
                        </div>
                        <h4 class="marathi-font">💰 मोफत नोंदणी</h4>
                        <p class="marathi-font">पूर्णपणे मोफत नोंदणी. प्रीमियम सदस्यत्व निवडणे ऐच्छिक.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-3 col-6 mb-4">
                    <span class="stat-number">10,000+</span>
                    <h5 class="marathi-font">सक्रिय सदस्य</h5>
                </div>
                <div class="col-lg-3 col-6 mb-4">
                    <span class="stat-number">2,500+</span>
                    <h5 class="marathi-font">यशस्वी विवाह</h5>
                </div>
                <div class="col-lg-3 col-6 mb-4">
                    <span class="stat-number">15+</span>
                    <h5 class="marathi-font">वर्षांचा अनुभव</h5>
                </div>
                <div class="col-lg-3 col-6 mb-4">
                    <span class="stat-number">50+</span>
                    <h5 class="marathi-font">शहरांमध्ये</h5>
                </div>
            </div>
        </div>
    </section>

    <!-- Success Stories -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="marathi-font">💖 यशोगाथा</h2>
                <p class="lead marathi-font">आमच्यामार्फत जुळलेल्या यशस्वी जोड्यांच्या हृदयस्पर्शी कहाण्या</p>
            </div>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center">
                            <img src="carousel/shivhar_chavan_create_5_diffrent_indian_maharashtriyan_couple_photo_on_wedding_d_da2e082d-233c-4e0d-9cac-45e12d0524ad.png" class="rounded-circle mb-3" width="100" height="100" alt="Couple" onerror="this.src='Images/default-couple.jpg'">
                            <h5 class="marathi-font">राजेश आणि प्रियंका</h5>
                            <p class="text-muted marathi-font">लग्न: २०२२</p>
                            <p class="marathi-font">"मराठी मॅट्रिमोनीद्वारे आम्ही एकमेकांना भेटलो. आता आम्ही एक आनंदी कुटुंब आहोत!"</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center">
                            <img src="carousel/shivhar_chavan_create_5_diffrent_indian_maharashtriyan_couple_photo_on_wedding_d_cffb4170-9de7-41cb-a3ec-0c139c1b5fcc.png" class="rounded-circle mb-3" width="100" height="100" alt="Couple" onerror="this.src='Images/default-couple.jpg'">
                            <h5 class="marathi-font">सचिन आणि माधुरी</h5>
                            <p class="text-muted marathi-font">लग्न: २०२३</p>
                            <p class="marathi-font">"सुरक्षित आणि विश्वासार्ह प्लॅटफॉर्म. आमच्या अपेक्षांपेक्षा जलद योग्य जोडीदार सापडला."</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center">
                            <img src="carousel/shivhar_chavan_create_5_diffrent_indian_maharashtriyan_couple_photo_on_wedding_d_a8d17bf1-99a9-4b3f-aee8-dfaaa7381000.png" class="rounded-circle mb-3" width="100" height="100" alt="Couple" onerror="this.src='Images/default-couple.jpg'">
                            <h5 class="marathi-font">आनंद आणि स्वाती</h5>
                            <p class="text-muted marathi-font">लग्न: २०२३</p>
                            <p class="marathi-font">"उत्कृष्ट सेवा आणि सहाय्य. संपूर्ण प्रक्रिया दरम्यान मार्गदर्शन मिळाले."</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <a href="SuccessStories.aspx" class="btn btn-primary marathi-font">📖 अधिक यशोगाथा वाचा</a>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-5" style="background: linear-gradient(135deg, #d63384 0%, #8b0000 100%); color: white;">
        <div class="container text-center">
            <h2 class="marathi-font mb-4">तयार आहात आपला आदर्श जोडीदार शोधायला?</h2>
            <p class="lead marathi-font mb-4">आजच नोंदणी करा आणि आपल्या जीवनातील सर्वोत्तम निर्णय घ्या</p>
            <a href="Registration.aspx" class="btn btn-light btn-lg marathi-font me-3">🚀 नोंदणी करा</a>
            <a href="Login.aspx" class="btn btn-outline-light btn-lg marathi-font">🔐 लॉगिन करा</a>
        </div>
    </section>
</asp:Content>