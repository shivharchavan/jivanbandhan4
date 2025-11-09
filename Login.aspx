<%@ Page Title="Marathi Matrimony - Login" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="JivanBandhan4.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            padding: 20px 15px;
            position: relative;
            overflow: hidden;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
            padding: 40px 35px;
            width: 100%;
            max-width: 420px;
            animation: slideInUp 0.6s ease-out;
            border: 2px solid rgba(255,215,0,0.3);
            position: relative;
            z-index: 2;
        }
        
        @keyframes slideInUp {
            from { 
                opacity: 0; 
                transform: translateY(30px) scale(0.96); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0) scale(1); 
            }
        }
        
        .login-logo {
            text-align: center;
            margin-bottom: 35px;
        }
        
        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 12px 30px rgba(139, 0, 0, 0.5);
            animation: float 3s ease-in-out infinite;
            border: 3px solid #FFD700;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-8px) rotate(5deg); }
        }
        
        .logo-icon i {
            font-size: 32px;
            color: #FFD700;
        }
        
        .login-title {
            color: #8B0000;
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 8px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.1);
        }
        
        .login-subtitle {
            color: #6c757d;
            font-size: 1rem;
            font-weight: 500;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 10px;
            font-size: 15px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 15px 18px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .form-control:focus {
            border-color: #8B0000;
            box-shadow: 0 4px 15px rgba(139, 0, 0, 0.25);
            background: white;
            transform: translateY(-1px);
        }
        
        .input-icon {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 16px;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            border: none;
            color: white;
            padding: 16px 35px;
            border-radius: 45px;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(139, 0, 0, 0.45);
            width: 100%;
            margin-top: 8px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(139, 0, 0, 0.6);
        }
        
        .login-links {
            text-align: center;
            margin-top: 30px;
        }
        
        .login-links a {
            color: #8B0000;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-block;
            margin: 0 12px;
            padding: 6px 14px;
            border-radius: 18px;
        }
        
        .login-links a:hover {
            color: #B22222;
            background: rgba(139, 0, 0, 0.08);
            transform: translateY(-1px);
        }
        
        /* Wedding Instruments Animation */
        .wedding-instruments {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
            overflow: hidden;
        }
        
        .instrument {
            position: absolute;
            font-size: 40px;
            color: rgba(255, 255, 255, 0.15);
            animation: floatInstrument 8s ease-in-out infinite;
            text-shadow: 0 0 10px rgba(255,215,0,0.3);
        }
        
        @keyframes floatInstrument {
            0%, 100% { 
                transform: translate(0, 0) rotate(0deg) scale(1);
            }
            25% { 
                transform: translate(20px, -15px) rotate(5deg) scale(1.1);
            }
            50% { 
                transform: translate(-15px, 10px) rotate(-3deg) scale(0.9);
            }
            75% { 
                transform: translate(10px, 15px) rotate(2deg) scale(1.05);
            }
        }
        
        .feature-highlights {
            display: flex;
            justify-content: space-around;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
        }
        
        .feature-item {
            text-align: center;
            padding: 0 12px;
        }
        
        .feature-icon {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #FFD700;
            font-size: 18px;
            margin: 0 auto 8px;
            box-shadow: 0 4px 12px rgba(139, 0, 0, 0.4);
        }
        
        .feature-text {
            font-size: 11px;
            color: #6c757d;
            font-weight: 500;
        }
        
        .password-toggle {
            position: absolute;
            right: 40px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            font-size: 15px;
            z-index: 3;
        }
        
        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .form-check-input:checked {
            background-color: #8B0000;
            border-color: #8B0000;
        }
        
        .forgot-password {
            color: #8B0000;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
            font-size: 14px;
        }
        
        .guest-demo {
            text-align: center;
            margin-top: 20px;
            padding: 12px;
            background: rgba(139, 0, 0, 0.04);
            border-radius: 12px;
            border-left: 3px solid #8B0000;
            font-size: 13px;
        }
        
        .demo-accounts {
            display: flex;
            justify-content: space-around;
            margin-top: 12px;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .demo-account {
            background: white;
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            font-size: 11px;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            min-width: 120px;
        }
        
        .demo-email {
            font-weight: bold;
            color: #8B0000;
            font-size: 10px;
        }
        
        .demo-password {
            color: #6c757d;
            font-size: 9px;
        }

        /* Lagan Celebration Animation */
        .celebration {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        }
        
        .flower {
            position: absolute;
            font-size: 20px;
            color: rgba(255, 215, 0, 0.4);
            animation: fall 6s linear infinite;
        }
        
        @keyframes fall {
            0% {
                transform: translateY(-100px) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 12px 15px;
            font-size: 14px;
        }
    </style>

    <div class="login-container">
        <!-- Wedding Instruments Background -->
        <div class="wedding-instruments">
            <div class="instrument" style="top: 10%; left: 5%; animation-delay: 0s;"><i class="fas fa-drum"></i></div>
            <div class="instrument" style="top: 70%; right: 8%; animation-delay: 2s;"><i class="fas fa-music"></i></div>
            <div class="instrument" style="bottom: 15%; left: 12%; animation-delay: 4s;"><i class="fas fa-ring"></i></div>
            <div class="instrument" style="top: 25%; right: 12%; animation-delay: 1s;"><i class="fas fa-heart"></i></div>
            <div class="instrument" style="top: 60%; left: 8%; animation-delay: 3s;"><i class="fas fa-guitar"></i></div>
            <div class="instrument" style="bottom: 25%; right: 15%; animation-delay: 5s;"><i class="fas fa-bell"></i></div>
        </div>
        
        <!-- Celebration Flowers -->
        <div class="celebration" id="celebrationContainer"></div>
        
        <div class="login-card">
            <div class="login-logo">
                <div class="logo-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <h1 class="login-title">जीवन बंधन</h1>
                <p class="login-subtitle">आपले स्वागत आहे! कृपया लॉगिन करा</p>
            </div>
            
            <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">
                <div class="form-group">
                    <label class="form-label">ईमेल पत्ता</label>
                    <div class="position-relative">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                            placeholder="आपला ईमेल पत्ता टाका" TextMode="Email"></asp:TextBox>
                        <div class="input-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">पासवर्ड</label>
                    <div class="position-relative">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                            placeholder="आपला पासवर्ड टाका" TextMode="Password"></asp:TextBox>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                    </div>
                </div>
                
                <div class="remember-forgot">
                    <div class="form-check">
                        <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="<%= chkRemember.ClientID %>">
                            मला लक्षात ठेवा
                        </label>
                    </div>
                    <a href="ForgotPassword.aspx" class="forgot-password">पासवर्ड विसरलात?</a>
                </div>
                
                <asp:Button ID="btnLogin" runat="server" Text="लॉगिन करा" 
                    CssClass="btn btn-login" OnClick="btnLogin_Click" />
                
                <!-- Guest Demo Accounts -->
                <div class="guest-demo">
                    <p style="margin-bottom: 8px; color: #6c757d; font-size: 12px;">
                        <i class="fas fa-info-circle"></i> चाचणीसाठी डेमो खाती:
                    </p>
                    <div class="demo-accounts">
                        <div class="demo-account" onclick="fillDemo('demo@jivanbandhan.com', 'demo123')">
                            <div class="demo-email">demo@jivanbandhan.com</div>
                            <div class="demo-password">पासवर्ड: demo123</div>
                        </div>
                        <div class="demo-account" onclick="fillDemo('test@jivanbandhan.com', 'test123')">
                            <div class="demo-email">test@jivanbandhan.com</div>
                            <div class="demo-password">पासवर्ड: test123</div>
                        </div>
                    </div>
                </div>
                
                <div class="login-links">
                    <p style="margin-bottom: 15px; color: #6c757d; font-size: 14px;">
                        खाते नाही? 
                    </p>
                    <a href="Registrations.aspx" style="background: linear-gradient(135deg, #8B0000 0%, #B22222 100%); color: white; padding: 10px 25px; border-radius: 22px; text-decoration: none; font-weight: bold; box-shadow: 0 4px 12px rgba(139, 0, 0, 0.4); font-size: 14px;">
                        <i class="fas fa-user-plus me-2"></i>नवीन खाते तयार करा
                    </a>
                </div>
            </asp:Panel>
            
            <!-- Feature Highlights -->
            <div class="feature-highlights">
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="feature-text">सुरक्षित</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div class="feature-text">जलद</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="feature-text">विश्वसनीय</div>
                </div>
            </div>
            
            <!-- Error Message -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" 
                CssClass="alert alert-danger mt-3 text-center" 
                style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
            </asp:Panel>

            <!-- Success Message -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" 
                CssClass="alert alert-success mt-3 text-center" 
                style="background: rgba(40, 167, 69, 0.1); color: #28a745;">
                <i class="fas fa-check-circle me-2"></i>
                <asp:Label ID="lblSuccess" runat="server" Text=""></asp:Label>
            </asp:Panel>
        </div>
    </div>

    <script>
        // Password toggle functionality
        function togglePassword() {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const toggleIcon = document.querySelector('.password-toggle i');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.className = 'fas fa-eye-slash';
            } else {
                passwordField.type = 'password';
                toggleIcon.className = 'fas fa-eye';
            }
        }

        // Fill demo account details
        function fillDemo(email, password) {
            document.getElementById('<%= txtEmail.ClientID %>').value = email;
            document.getElementById('<%= txtPassword.ClientID %>').value = password;
            createCelebration();

            // Show success message
            const successPanel = document.getElementById('<%= pnlSuccess.ClientID %>');
            const successLabel = document.getElementById('<%= lblSuccess.ClientID %>');
            const errorPanel = document.getElementById('<%= pnlError.ClientID %>');
            
            if (successPanel && successLabel) {
                successPanel.style.display = 'block';
                successPanel.style.visibility = 'visible';
                successLabel.textContent = 'डेमो खाते सेट केले! कृपया लॉगिन करा.';
            }
            
            if (errorPanel) {
                errorPanel.style.display = 'none';
            }
        }

        // Create celebration flowers
        function createCelebration() {
            const container = document.getElementById('celebrationContainer');
            container.innerHTML = '';
            
            const flowers = ['🌸', '💮', '🏵️', '🌹', '🌺', '🌻', '🌼'];
            
            for (let i = 0; i < 15; i++) {
                const flower = document.createElement('div');
                flower.className = 'flower';
                flower.innerHTML = flowers[Math.floor(Math.random() * flowers.length)];
                
                // Random position and animation
                flower.style.left = Math.random() * 100 + '%';
                flower.style.animationDelay = Math.random() * 6 + 's';
                flower.style.animationDuration = (Math.random() * 3 + 4) + 's';
                flower.style.fontSize = (Math.random() * 15 + 15) + 'px';
                
                container.appendChild(flower);
            }
        }

        // Create wedding instruments
        function createInstruments() {
            const container = document.querySelector('.wedding-instruments');
            const instruments = [
                {icon: 'fas fa-drum', name: 'ढोल'},
                {icon: 'fas fa-music', name: 'शहनाई'},
                {icon: 'fas fa-ring', name: 'मंगळसूत्र'},
                {icon: 'fas fa-heart', name: 'प्रेम'},
                {icon: 'fas fa-guitar', name: 'तंबोरा'},
                {icon: 'fas fa-bell', name: 'घुंगरू'}
            ];
            
            container.innerHTML = '';
            
            instruments.forEach((instrument, index) => {
                const inst = document.createElement('div');
                inst.className = 'instrument';
                inst.innerHTML = `<i class="${instrument.icon}"></i>`;
                
                // Random positioning
                inst.style.left = Math.random() * 80 + 10 + '%';
                inst.style.top = Math.random() * 80 + 10 + '%';
                inst.style.animationDelay = (index * 1.5) + 's';
                inst.style.fontSize = (Math.random() * 20 + 30) + 'px';
                
                container.appendChild(inst);
            });
        }

        // Add input focus effects
        document.addEventListener('DOMContentLoaded', function() {
            createInstruments();
            createCelebration();
            
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });

            // Auto focus on email field
            const emailField = document.getElementById('<%= txtEmail.ClientID %>');
            if (emailField) {
                setTimeout(() => {
                    emailField.focus();
                }, 400);
            }
        });

        // Button ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const button = document.getElementById('<%= btnLogin.ClientID %>');
            if (button) {
                button.addEventListener('click', function(e) {
                    const rect = this.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    const ripple = document.createElement('span');
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.className = 'ripple-effect';
                    ripple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.6);
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                    `;
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            }
        });

        // Add ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Auto-hide messages after 5 seconds
        function autoHideMessages() {
            setTimeout(() => {
                const errorPanel = document.getElementById('<%= pnlError.ClientID %>');
                const successPanel = document.getElementById('<%= pnlSuccess.ClientID %>');

                if (errorPanel) errorPanel.style.display = 'none';
                if (successPanel) successPanel.style.display = 'none';
            }, 5000);
        }

        // Call auto-hide on page load
        document.addEventListener('DOMContentLoaded', autoHideMessages);

        // Continuous celebration animation
        setInterval(createCelebration, 7000);
    </script>
</asp:Content>