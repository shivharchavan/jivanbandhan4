<%@ Page Title="मुखपृष्ठ" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /* Enhanced Home Page Styles */
        .hero-section {
            background: /*linear-gradient(135deg, rgba(139, 0, 0, 0.9) 0%, rgba(178, 34, 34, 0.8) 100%), */
                        url('https://images.unsplash.com/photo-1583939003579-730e3918a45a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: white;
            padding: 150px 0 100px;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            animation: grain 8s steps(10) infinite;
        }

        @keyframes grain {
            0%, 100% { transform: translate(0, 0); }
            10% { transform: translate(-5%, -10%); }
            20% { transform: translate(-15%, 5%); }
            30% { transform: translate(7%, -25%); }
            40% { transform: translate(-5%, 25%); }
            50% { transform: translate(-15%, 10%); }
            60% { transform: translate(15%, 0%); }
            70% { transform: translate(0%, 15%); }
            80% { transform: translate(3%, 35%); }
            90% { transform: translate(-10%, 10%); }
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .marathi-font {
            font-family: 'Nirmala UI', 'Inter', sans-serif;
            font-weight: 600;
        }

        .display-3 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .lead {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.95;
        }

        /* Enhanced Quick Search */
        .quick-search-container {
            margin-top: -80px;
            position: relative;
            z-index: 100;
        }

        .quick-search {
            background: var(--white);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: var(--shadow-large);
            border: 1px solid rgba(139, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        /* Enhanced Cards */
        .feature-card {
            background: var(--white);
            border-radius: 20px;
            padding: 2.5rem 2rem;
            margin: 1rem 0;
            box-shadow: var(--shadow-soft);
            transition: all 0.4s ease;
            border: 1px solid rgba(139, 0, 0, 0.1);
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-large);
        }

        .feature-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        /* Enhanced Stats */
        .stats-section {
            background: var(--gradient-primary);
            color: white;
            padding: 100px 0;
            position: relative;
        }

        .stats-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="white" opacity="0.3"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
        }

        .stat-item {
            position: relative;
            z-index: 2;
        }

        .stat-number {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        /* Enhanced Buttons */
        .btn-gold {
            background: var(--gradient-gold);
            color: var(--primary-maroon);
            border: none;
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-gold::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn-gold:hover::before {
            left: 100%;
        }

        .btn-gold:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
        }

        .btn-maroon {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(139, 0, 0, 0.3);
        }

        .btn-maroon:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 0, 0, 0.4);
            color: white;
        }

        /* Enhanced Carousel */
        .success-carousel {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow-medium);
        }

        .success-story {
            background: var(--white);
            border-radius: 20px;
            padding: 3rem;
            margin: 2rem;
            box-shadow: var(--shadow-soft);
            border-left: 5px solid var(--primary-maroon);
            position: relative;
        }

        .success-story::before {
            content: '"';
            position: absolute;
            top: -20px;
            left: 30px;
            font-size: 6rem;
            color: var(--primary-maroon);
            opacity: 0.1;
            font-family: serif;
        }

        .testimonial-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-maroon);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* How It Works */
        .how-it-works-step {
            text-align: center;
            padding: 2rem 1rem;
            position: relative;
        }

        .step-number {
            width: 80px;
            height: 80px;
            background: var(--gradient-primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            margin: 0 auto 1.5rem;
            box-shadow: 0 4px 15px rgba(139, 0, 0, 0.3);
            border: 4px solid var(--white);
        }

        /* Floating Elements */
        .floating-element {
            position: absolute;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .display-3 {
                font-size: 2.5rem;
            }
            
            .hero-section {
                padding: 120px 0 80px;
            }
            
            .quick-search {
                padding: 2rem;
                margin: 0 1rem;
            }
            
            .feature-card {
                padding: 2rem 1.5rem;
            }
        }

        /* Section Spacing */
        .section-padding {
            padding: 100px 0;
        }

        .section-title {
            position: relative;
            margin-bottom: 3rem;
            text-align: center;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--gradient-primary);
            border-radius: 2px;
        }

        /* Trust Badges */
        .trust-badge {
            background: var(--white);
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: var(--shadow-soft);
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .trust-badge:hover {
            border-color: var(--primary-maroon);
            transform: translateY(-5px);
        }
    </style>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center min-vh-100">
                <div class="col-lg-8 mx-auto text-center hero-content">
                    <h1 class="display-3 marathi-font animate__animated animate__fadeInDown">
                        जीवनबंधन मध्ये आपले स्वागत आहे
                    </h1>
                    <p class="lead marathi-font animate__animated animate__fadeInUp">
                        मराठी संस्कृती, संस्कार आणि सनातन मूल्यांवर आधारित विश्वासार्ह विवाह संस्था.<br>
                        आपल्या जीवनसाथीच्या शोधात आम्ही आपल्या सोबत आहोत.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap animate__animated animate__fadeInUp">
                        <asp:Button ID="btnFreeRegister" runat="server" Text="विनामूल्य नोंदणी" 
                            CssClass="btn btn-gold btn-lg" OnClick="btnFreeRegister_Click" />
                        <asp:Button ID="btnSearch" runat="server" Text="योग्य जोडीदार शोधा" 
                            CssClass="btn btn-maroon btn-lg" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Search Section -->
    <div class="container quick-search-container">
        <div class="quick-search">
            <h3 class="text-center marathi-font mb-4 text-primary">त्वरित शोध</h3>
            <p class="text-center text-muted mb-4">आपल्या आवडीनुसार योग्य जोडीदार शोधा</p>
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label marathi-font text-dark mb-2">मी शोधत आहे</label>
                        <asp:DropDownList ID="ddlSearchGender" runat="server" CssClass="form-control form-control-lg">
                            <asp:ListItem Value="">निवडा</asp:ListItem>
                            <asp:ListItem Value="Male">वर</asp:ListItem>
                            <asp:ListItem Value="Female">वधू</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label marathi-font text-dark mb-2">वय</label>
                        <asp:DropDownList ID="ddlSearchAge" runat="server" CssClass="form-control form-control-lg">
                            <asp:ListItem Value="">निवडा</asp:ListItem>
                            <asp:ListItem Value="18-25">18-25 वर्ष</asp:ListItem>
                            <asp:ListItem Value="26-30">26-30 वर्ष</asp:ListItem>
                            <asp:ListItem Value="31-35">31-35 वर्ष</asp:ListItem>
                            <asp:ListItem Value="36-40">36-40 वर्ष</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label marathi-font text-dark mb-2">शहर</label>
                        <asp:DropDownList ID="ddlSearchCity" runat="server" CssClass="form-control form-control-lg">
                            <asp:ListItem Value="">निवडा</asp:ListItem>
                            <asp:ListItem Value="Pune">पुणे</asp:ListItem>
                            <asp:ListItem Value="Mumbai">मुंबई</asp:ListItem>
                            <asp:ListItem Value="Nagpur">नागपूर</asp:ListItem>
                            <asp:ListItem Value="Nashik">नाशिक</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="form-label text-white mb-2">‎</label>
                        <asp:Button ID="btnQuickSearch" runat="server" Text="शोधा" 
                            CssClass="btn btn-maroon btn-lg w-100" OnClick="btnQuickSearch_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <section class="section-padding bg-light">
        <div class="container">
            <h2 class="section-title marathi-font">आमचे विशेषत:</h2>
            <div class="row">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <i class="fas fa-shield-alt feature-icon"></i>
                        <h4 class="marathi-font h5 mb-3">🔒 सुरक्षित आणि सत्यापित</h4>
                        <p class="text-muted">प्रत्येक प्रोफाइल सखोल तपासणीनंतर मान्य करण्यात येते. आपली गोपनीयता आमच्या काळजीचे केंद्रबिंदू आहे.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <i class="fas fa-users feature-icon"></i>
                        <h4 class="marathi-font h5 mb-3">🌍 महाराष्ट्रभर</h4>
                        <p class="text-muted">महाराष्ट्रातील सर्व ३६ जिल्हे आणि प्रत्येक गावापर्यंत पोहोच. आपल्या भौगोलिक आणि सांस्कृतिक आवडीनुसार शोध.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <i class="fas fa-heart feature-icon"></i>
                        <h4 class="marathi-font h5 mb-3">💖 संस्कारी कुटुंबे</h4>
                        <p class="text-muted">मराठी संस्कृती आणि सनातन मूल्यांना महत्व देणाऱ्या कुटुंबांचा विशेष डेटाबेस.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-3 col-md-6 stat-item">
                    <div class="stat-number" data-count="10000">०</div>
                    <p class="marathi-font h5">सक्रिय सदस्य</p>
                </div>
                <div class="col-lg-3 col-md-6 stat-item">
                    <div class="stat-number" data-count="5000">०</div>
                    <p class="marathi-font h5">यशस्वी विवाह</p>
                </div>
                <div class="col-lg-3 col-md-6 stat-item">
                    <div class="stat-number" data-count="36">०</div>
                    <p class="marathi-font h5">जिल्हे</p>
                </div>
                <div class="col-lg-3 col-md-6 stat-item">
                    <div class="stat-number" data-count="99">०</div>
                    <p class="marathi-font h5">समाधानी कुटुंबे</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title marathi-font">जीवनबंधन कसे काम करते?</h2>
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="how-it-works-step">
                        <div class="step-number">१</div>
                        <h4 class="marathi-font h5 mb-3">निःशुल्क नोंदणी</h4>
                        <p class="text-muted">आपली मूलभूत माहिती भरून विनामूल्य खाते तयार करा</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="how-it-works-step">
                        <div class="step-number">२</div>
                        <h4 class="marathi-font h5 mb-3">प्रोफाइल पूर्ण करा</h4>
                        <p class="text-muted">तपशीलवार माहिती भरून आपली प्रोफाइल पूर्ण करा</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="how-it-works-step">
                        <div class="step-number">३</div>
                        <h4 class="marathi-font h5 mb-3">योग्य जोडीदार शोधा</h4>
                        <p class="text-muted">आपल्या आवडीनुसार योग्य जोडीदार शोधा</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="how-it-works-step">
                        <div class="step-number">४</div>
                        <h4 class="marathi-font h5 mb-3">संपर्क साधा</h4>
                        <p class="text-muted">आवडीच्या प्रोफाइलशी संपर्क साधा आणि संभाषण सुरू करा</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Success Stories -->
    <section class="section-padding bg-light">
        <div class="container">
            <h2 class="section-title marathi-font">यशोगाथा</h2>
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div id="successCarousel" class="carousel slide success-carousel" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <div class="success-story text-center">
                                    <img src="carousel/shivhar_chavan_create_5_diffrent_indian_maharashtriyan_couple_photo_on_wedding_d_5ba1feca-e057-4e14-847f-5232811b42ec (1).png"
<%--                                    <img src="https://via.placeholder.com/100x100/8B0000/FFFFFF?text=र" --%>
                                         class="testimonial-img mb-4" alt="Couple">
                                    <h4 class="marathi-font h5 mb-3">रजत आणि प्रियांका</h4>
                                    <p class="text-muted mb-4">"जीवनबंधन मधून आमची ओळख झाली आणि आता आम्ही आनंदी पती-पत्नी आहोत. त्यांचे सत्यापन प्रक्रिया आणि सहाय्य खरोखरच उत्तम आहे."</p>
                                    <div class="text-warning">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <div class="success-story text-center">
                                    <img src="carousel/shivhar_chavan_create_5_diffrent_indian_maharashtriyan_couple_photo_on_wedding_d_8dc20384-2e5e-4c1f-bb08-c275caf9b003.png"/>
<%--                                    <img src="https://via.placeholder.com/100x100/B22222/FFFFFF?text=स" --%>
                                         class="testimonial-img mb-4" alt="Couple">
                                    <h4 class="marathi-font h5 mb-3">सागर आणि अंजली</h4>
                                    <p class="text-muted mb-4">"आम्हाला एकमेकांना शोधण्यासाठी फक्त १५ दिवस लागले! जीवनबंधनचे सोपे आंतरजाल आणि विस्तृत शोध पर्यायांमुळे आमचा शोध सोपा झाला."</p>
                                    <div class="text-warning">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#successCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#successCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Trust Indicators -->
    <section class="section-padding">
        <div class="container">
            <h2 class="section-title marathi-font">आमच्यावर विश्वास ठेवा</h2>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="trust-badge">
                        <i class="fas fa-user-shield fa-3x text-primary mb-3"></i>
                        <h5 class="marathi-font">१००% सुरक्षित</h5>
                        <p class="text-muted">आपली व्यक्तिगत माहिती संरक्षित</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="trust-badge">
                        <i class="fas fa-headset fa-3x text-primary mb-3"></i>
                        <h5 class="marathi-font">२४x७ सहाय्य</h5>
                        <p class="text-muted">कुठल्याही वेळी आमच्या संपर्कात रहा</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="trust-badge">
                        <i class="fas fa-badge-check fa-3x text-primary mb-3"></i>
                        <h5 class="marathi-font">सत्यापित प्रोफाइल</h5>
                        <p class="text-muted">प्रत्येक प्रोफाइल तपासून मान्य</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Final CTA -->
    <section class="stats-section">
        <div class="container text-center">
            <h2 class="marathi-font display-5 mb-4">आजच योग्य जोडीदार शोधण्यास सुरुवात करा!</h2>
            <p class="marathi-font h5 mb-5 opacity-90">आपले स्वप्नांचे जीवनसाथी शोधण्यासाठी आमच्यासोबत सामील व्हा</p>
            <div class="d-flex gap-4 justify-content-center flex-wrap">
                <asp:Button ID="btnJoinNow" runat="server" Text="सामील व्हा" 
                    CssClass="btn btn-gold btn-lg px-5" OnClick="btnJoinNow_Click" />
                <asp:Button ID="btnContact" runat="server" Text="संपर्क करा" 
                    CssClass="btn btn-outline-light btn-lg px-5" OnClick="btnContact_Click" />
            </div>
        </div>
    </section>

    <!-- Enhanced JavaScript -->
    <script>
        // Animated Counter
        function animateCounter() {
            const counters = document.querySelectorAll('.stat-number');
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-count'));
                const increment = target / 200;
                let current = 0;

                const updateCounter = () => {
                    if (current < target) {
                        current += increment;
                        counter.textContent = Math.floor(current);
                        setTimeout(updateCounter, 10);
                    } else {
                        counter.textContent = target;
                    }
                };

                updateCounter();
            });
        }

        // Intersection Observer for animations
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate__animated', 'animate__fadeInUp');
                    if (entry.target.classList.contains('stat-number')) {
                        animateCounter();
                    }
                }
            });
        }, { threshold: 0.1 });

        // Observe all elements that need animation
        document.querySelectorAll('.feature-card, .how-it-works-step, .trust-badge').forEach(el => {
            observer.observe(el);
        });

        // Smooth scrolling for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Parallax effect for hero section
        window.addEventListener('scroll', function () {
            const scrolled = window.pageYOffset;
            const hero = document.querySelector('.hero-section');
            if (hero) {
                hero.style.transform = 'translateY(' + (scrolled * 0.5) + 'px)';
            }
        });

        console.log('जीवनबंधन - Professional Marathi Matrimony Site Loaded Successfully!');
    </script>
</asp:Content>