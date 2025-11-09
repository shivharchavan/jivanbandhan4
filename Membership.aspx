


<%@ Page Title="Marathi Matrimony - Premium Membership" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Membership.aspx.cs" Inherits="JivanBandhan4.Membership" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .membership-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #d63384 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .membership-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><polygon fill="rgba(255,255,255,0.05)" points="0,1000 1000,0 1000,1000"/></svg>');
            background-size: cover;
            animation: float 20s infinite linear;
        }
        
        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(360deg); }
        }
        
        .page-header {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(20px);
            color: #2c3e50;
            border-radius: 30px;
            padding: 50px 40px;
            margin-bottom: 40px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.15);
            position: relative;
            border: 1px solid rgba(255,255,255,0.3);
            text-align: center;
            z-index: 1;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 32px;
            z-index: -1;
            opacity: 0.3;
        }
        
        .plans-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 35px;
            margin: 50px 0;
            position: relative;
            z-index: 1;
        }
        
        .plan-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 0;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            border: 3px solid transparent;
        }
        
        .plan-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
        }
        
        .plan-card:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 30px 70px rgba(0,0,0,0.25);
        }
        
        .plan-card:hover::before {
            opacity: 0.1;
        }
        
        .plan-card.popular {
            border-color: #ffd700;
            transform: scale(1.05);
            animation: glow 2s infinite alternate;
        }
        
        .plan-card.popular:hover {
            transform: scale(1.05) translateY(-15px);
        }
        
        @keyframes glow {
            from { box-shadow: 0 20px 50px rgba(255, 215, 0, 0.3); }
            to { box-shadow: 0 25px 60px rgba(255, 215, 0, 0.5); }
        }
        
        .plan-header {
            padding: 40px 30px 30px;
            text-align: center;
            border-bottom: 1px solid rgba(240,240,240,0.8);
            position: relative;
            overflow: hidden;
        }
        
        .plan-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.5), transparent);
        }
        
        .plan-badge {
            position: absolute;
            top: 25px;
            right: -35px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            color: white;
            padding: 10px 45px;
            transform: rotate(45deg);
            font-size: 0.85rem;
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
            z-index: 2;
        }
        
        .plan-name {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }
        
        .plan-name::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            border-radius: 3px;
        }
        
        .plan-price {
            font-size: 3.5rem;
            font-weight: bold;
            margin: 25px 0;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            position: relative;
        }
        
        .plan-price::before {
            content: '₹';
            font-size: 2rem;
            position: absolute;
            top: -10px;
            left: -25px;
        }
        
        .plan-duration {
            color: #6c757d;
            font-size: 1.1rem;
            font-weight: 500;
        }
        
        .plan-features {
            padding: 35px 30px;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .feature-item {
            padding: 15px 0;
            border-bottom: 1px solid rgba(248,249,250,0.8);
            display: flex;
            align-items: center;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .feature-item:hover {
            transform: translateX(5px);
            background: rgba(248,249,250,0.5);
            border-radius: 10px;
            padding-left: 10px;
        }
        
        .feature-item:last-child {
            border-bottom: none;
        }
        
        .feature-icon {
            width: 24px;
            height: 24px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 0.8rem;
            font-weight: bold;
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.3);
            flex-shrink: 0;
        }
        
        .feature-icon.cross {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
        }
        
        .plan-actions {
            padding: 0 30px 35px;
            text-align: center;
        }
        
        .btn-plan {
            width: 100%;
            padding: 18px;
            border: none;
            border-radius: 20px;
            font-weight: bold;
            font-size: 1.2rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .btn-plan::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-plan:hover::before {
            left: 100%;
        }
        
        .btn-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .btn-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }
        
        .btn-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }
        
        .btn-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }
        
        .btn-plan:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
        }
        
        .current-plan-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: bold;
            margin-top: 15px;
            display: inline-block;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            animation: pulse-green 2s infinite;
        }
        
        @keyframes pulse-green {
            0% { transform: scale(1); box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4); }
            50% { transform: scale(1.05); box-shadow: 0 8px 25px rgba(40, 167, 69, 0.6); }
            100% { transform: scale(1); box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4); }
        }
        
        .benefits-section {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 50px 40px;
            margin: 50px 0;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        
        .benefits-section::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0.2;
        }
        
        .benefit-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 35px;
            margin-top: 40px;
        }
        
        .benefit-card {
            text-align: center;
            padding: 30px 25px;
            border-radius: 20px;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .benefit-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
        }
        
        .benefit-card:hover {
            transform: translateY(-10px) scale(1.03);
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .benefit-icon {
            font-size: 3.5rem;
            margin-bottom: 25px;
            display: block;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            transition: all 0.3s ease;
        }
        
        .benefit-card:hover .benefit-icon {
            transform: scale(1.2) rotate(5deg);
        }
        
        .faq-section {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 50px 40px;
            margin: 50px 0;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        
        .faq-section::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0.2;
        }
        
        .faq-item {
            border-bottom: 1px solid rgba(233, 236, 239, 0.8);
            padding: 25px 0;
            transition: all 0.3s ease;
        }
        
        .faq-item:hover {
            background: rgba(248,249,250,0.5);
            border-radius: 15px;
            padding: 25px 20px;
            margin: 0 -20px;
        }
        
        .faq-question {
            font-weight: bold;
            color: #2c3e50;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        
        .faq-question:hover {
            color: #d63384;
        }
        
        .faq-answer {
            color: #6c757d;
            margin-top: 15px;
            display: none;
            line-height: 1.6;
            padding-right: 20px;
        }
        
        .faq-item.active .faq-answer {
            display: block;
            animation: fadeIn 0.5s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .payment-methods {
            display: flex;
            justify-content: center;
            gap: 25px;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        
        .payment-method {
            width: 80px;
            height: 50px;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
        }
        
        .payment-method:hover {
            transform: translateY(-5px) scale(1.1);
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        /* Silver Plan */
        .silver-plan {
            border: 3px solid #c0c0c0;
        }
        
        .silver-plan .plan-name {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        /* Gold Plan */
        .gold-plan {
            border: 3px solid #ffd700;
        }
        
        .gold-plan .plan-name {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .gold-plan .plan-badge {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
        }
        
        /* Platinum Plan */
        .platinum-plan {
            border: 3px solid #e5e4e2;
        }
        
        .platinum-plan .plan-name {
            background: linear-gradient(135deg, #333 0%, #666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .platinum-plan .plan-badge {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .membership-tag {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: bold;
            margin-left: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }
        
        .tag-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .tag-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }
        
        .tag-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }
        
        .tag-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        @media (max-width: 1200px) {
            .plans-container {
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 30px;
            }
        }
        
        @media (max-width: 768px) {
            .plans-container {
                grid-template-columns: 1fr;
            }
            
            .plan-card.popular {
                transform: scale(1);
            }
            
            .plan-card.popular:hover {
                transform: translateY(-15px);
            }
            
            .page-header {
                padding: 40px 25px;
            }
            
            .benefits-section, .faq-section {
                padding: 40px 25px;
            }
            
            .benefit-grid {
                grid-template-columns: 1fr;
                gap: 25px;
            }
            
            .payment-methods {
                gap: 15px;
            }
            
            .payment-method {
                width: 70px;
                height: 45px;
                font-size: 1.8rem;
            }
        }
        
        @media (max-width: 576px) {
            .plan-card {
                margin: 0 10px;
            }
            
            .plan-header {
                padding: 30px 20px 25px;
            }
            
            .plan-features {
                padding: 25px 20px;
            }
            
            .plan-actions {
                padding: 0 20px 25px;
            }
            
            .btn-plan {
                padding: 15px;
                font-size: 1.1rem;
            }
        }

        .floating-elements {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 0;
        }
        
        .floating-element {
            position: absolute;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float-element 15s infinite linear;
        }
        
        @keyframes float-element {
            0% { transform: translateY(100vh) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(360deg); }
        }
    </style>

    <div class="membership-container">


          <div class="container mt-4">
        <h1><asp:Literal ID="litPageTitle" runat="server" Text="Welcome to JivanBandhan"></asp:Literal></h1>
        <p><asp:Literal ID="litPageDescription" runat="server" Text="Find your perfect life partner..."></asp:Literal></p>
        
        <!-- Dynamic content साठी Literal controls वापरा -->
    </div>




        <!-- Floating Elements -->
        <div class="floating-elements">
            <div class="floating-element" style="width: 100px; height: 100px; top: 10%; left: 10%; animation-delay: 0s;"></div>
            <div class="floating-element" style="width: 150px; height: 150px; top: 20%; right: 15%; animation-delay: 2s;"></div>
            <div class="floating-element" style="width: 80px; height: 80px; bottom: 30%; left: 20%; animation-delay: 4s;"></div>
            <div class="floating-element" style="width: 120px; height: 120px; bottom: 20%; right: 25%; animation-delay: 6s;"></div>
        </div>

        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="marathi-font" style="font-size: 3rem; margin-bottom: 20px;">
                    ⭐ प्रीमियम सदस्यत्व योजना
                </h1>
                <p class="marathi-font mb-0" style="font-size: 1.3rem; opacity: 0.9;">
                    तुमच्या आदर्श जोडीदार शोधण्याच्या सफरेत प्रीमियम बनवा
                </p>
                
                <!-- Current Plan Status -->
                <asp:Panel ID="pnlCurrentPlan" runat="server" CssClass="mt-4">
                    <div class="current-plan-badge marathi-font">
                        📱 सध्याची योजना: <asp:Label ID="lblCurrentPlan" runat="server" Text="Free"></asp:Label>
                        <span class="membership-tag tag-free" id="currentPlanTag" runat="server">Free</span>
                    </div>
                </asp:Panel>
            </div>

            <!-- Membership Plans -->
            <div class="plans-container">
                <!-- Free Plan -->
                <div class="plan-card">
                    <div class="plan-header">
                        <div class="plan-name marathi-font">🆓 विनामूल्य</div>
                        <div class="plan-price marathi-font">0</div>
                        <div class="plan-duration marathi-font">कायमस्वरूपी</div>
                    </div>
                    
                    <div class="plan-features">
                        <ul class="feature-list">
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                मूलभूत प्रोफाइल तयार करणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 5 प्रोफाइल पाहणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                मर्यादित शोध पर्याय
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 2 स्वारस्य पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 5 संदेश पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon cross">✗</span>
                                प्रीमियम प्रोफाइल पाहणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon cross">✗</span>
                                संपर्क क्रमांक पाहणे
                            </li>
                        </ul>
                    </div>
                    
                    <div class="plan-actions">
                        <asp:Button ID="btnCurrentFree" runat="server" Text="🔒 सध्याची योजना" 
                            CssClass="btn-plan btn-free marathi-font" Enabled="false" />
                    </div>
                </div>

                <!-- Silver Plan -->
                <div class="plan-card silver-plan">
                    <div class="plan-header">
                        <div class="plan-name marathi-font">🥈 रौप्य योजना</div>
                        <div class="plan-price marathi-font">999</div>
                        <div class="plan-duration marathi-font">3 महिने</div>
                    </div>
                    
                    <div class="plan-features">
                        <ul class="feature-list">
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                सर्व विनामूल्य सुविधा
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                अमर्यादित प्रोफाइल दृश्ये
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                प्राधान्य शोध परिणाम
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 10 स्वारस्य पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                प्रीमियम प्रोफाइल पाहणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 10 संदेश पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon cross">✗</span>
                                संपर्क क्रमांक पाहणे
                            </li>
                        </ul>
                    </div>
                    
                    <div class="plan-actions">
                        <asp:Button ID="btnSelectSilver" runat="server" Text="🥈 रौप्य निवडा" 
                            CssClass="btn-plan btn-silver marathi-font" OnClick="btnSelectSilver_Click" />
                    </div>
                </div>

                <!-- Gold Plan (Popular) -->
                <div class="plan-card gold-plan popular">
                    <div class="plan-badge marathi-font">लोकप्रिय</div>
                    
                    <div class="plan-header">
                        <div class="plan-name marathi-font">🥇 सुवर्ण योजना</div>
                        <div class="plan-price marathi-font">1,999</div>
                        <div class="plan-duration marathi-font">6 महिने</div>
                    </div>
                    
                    <div class="plan-features">
                        <ul class="feature-list">
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                सर्व रौप्य सुविधा
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                प्रोफाइल हायलाइटिंग
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                अग्रिम शोध फिल्टर
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 50 स्वारस्य पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                दररोज 100 संदेश पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                प्राधान्य समर्थन
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon cross">✗</span>
                                संपर्क क्रमांक पाहणे
                            </li>
                        </ul>
                    </div>
                    
                    <div class="plan-actions">
                        <asp:Button ID="btnSelectGold" runat="server" Text="🥇 सुवर्ण निवडा" 
                            CssClass="btn-plan btn-gold marathi-font" OnClick="btnSelectGold_Click" />
                    </div>
                </div>

                <!-- Platinum Plan -->
                <div class="plan-card platinum-plan">
                    <div class="plan-header">
                        <div class="plan-name marathi-font">💎 प्लॅटिनम योजना</div>
                        <div class="plan-price marathi-font">2,999</div>
                        <div class="plan-duration marathi-font">12 महिने</div>
                    </div>
                    
                    <div class="plan-features">
                        <ul class="feature-list">
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                सर्व सुवर्ण सुविधा
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                टॉप प्रोफाइल पोझिशनिंग
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                वैयक्तिक सहाय्यक
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                प्राधान्य मिलन कार्यक्रम
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                24x7 विशेष समर्थन
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                अमर्यादित स्वारस्य पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                अमर्यादित संदेश पाठवणे
                            </li>
                            <li class="feature-item marathi-font">
                                <span class="feature-icon">✓</span>
                                संपर्क क्रमांक पाहणे
                            </li>
                        </ul>
                    </div>
                    
                    <div class="plan-actions">
                        <asp:Button ID="btnSelectPlatinum" runat="server" Text="💎 प्लॅटिनम निवडा" 
                            CssClass="btn-plan btn-platinum marathi-font" OnClick="btnSelectPlatinum_Click" />
                    </div>
                </div>
            </div>

            <!-- Benefits Section -->
            <div class="benefits-section">
                <h2 class="text-center marathi-font mb-4" style="font-size: 2.5rem; background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    ⭐ प्रीमियम सदस्यत्वचे फायदे
                </h2>
                
                <div class="benefit-grid">
                    <div class="benefit-card">
                        <i class="fas fa-bolt benefit-icon"></i>
                        <h5 class="marathi-font" style="font-size: 1.3rem; margin-bottom: 15px;">प्राधान्य दृश्यता</h5>
                        <p class="marathi-font text-muted" style="line-height: 1.6;">तुमचे प्रोफाइल इतर प्रीमियम सदस्यांसमोर प्रथम दाखवले जाईल</p>
                    </div>
                    
                    <div class="benefit-card">
                        <i class="fas fa-search benefit-icon"></i>
                        <h5 class="marathi-font" style="font-size: 1.3rem; margin-bottom: 15px;">अग्रिम शोध</h5>
                        <p class="marathi-font text-muted" style="line-height: 1.6;">तपशीलवार शोध फिल्टरसह तुमच्या आवडीनुसार प्रोफाइल शोधा</p>
                    </div>
                    
                    <div class="benefit-card">
                        <i class="fas fa-comments benefit-icon"></i>
                        <h5 class="marathi-font" style="font-size: 1.3rem; margin-bottom: 15px;">अमर्यादित संवाद</h5>
                        <p class="marathi-font text-muted" style="line-height: 1.6;">कोणत्याही प्रोफाइलला संदेश पाठवा आणि त्वरीत प्रतिसाद मिळवा</p>
                    </div>
                    
                    <div class="benefit-card">
                        <i class="fas fa-shield-alt benefit-icon"></i>
                        <h5 class="marathi-font" style="font-size: 1.3rem; margin-bottom: 15px;">सुरक्षित संपर्क</h5>
                        <p class="marathi-font text-muted" style="line-height: 1.6;">प्रीमियम प्रोफाइल्सची पार्श्वभूमी तपासलेली असते</p>
                    </div>
                </div>
            </div>

            <!-- Payment Methods -->
            <div class="benefits-section text-center">
                <h3 class="marathi-font mb-4" style="font-size: 2.2rem; background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">💳 पेमेंट पद्धती</h3>
                
                <div class="payment-methods">
                    <div class="payment-method">💳</div>
                    <div class="payment-method">🏦</div>
                    <div class="payment-method">📱</div>
                    <div class="payment-method">💰</div>
                    <div class="payment-method">🔗</div>
                </div>
                
                <p class="marathi-font text-muted mt-4" style="font-size: 1.1rem; line-height: 1.6;">
                    सर्व पेमेंट पद्धती 100% सुरक्षित आहेत. तुमची वैयक्तिक माहिती गोपनीय राखली जाते.
                </p>
            </div>

            <!-- FAQ Section -->
            <div class="faq-section">
                <h2 class="text-center marathi-font mb-4" style="font-size: 2.5rem; background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    ❓ वारंवार विचारले जाणारे प्रश्न
                </h2>
                
                <div class="faq-item">
                    <div class="faq-question marathi-font" onclick="toggleFAQ(this)">
                        प्रीमियम सदस्यत्व कसे कार्य करते?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer marathi-font">
                        प्रीमियम सदस्यत्व निवडल्यानंतर, तुम्हाला निवडलेल्या योजनेच्या कालावधीसाठी सर्व प्रीमियम सुविधा मिळतील. 
                        तुमचे प्रोफाइल प्राधान्य दर्जाचे होईल आणि तुम्हाला अधिक जुळणारे प्रोफाइल्स दिसतील.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question marathi-font" onclick="toggleFAQ(this)">
                        मी पेमेंट केल्यानंतर किती वेळात प्रीमियम सक्रिय होईल?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer marathi-font">
                        पेमेंट पुष्टी झाल्यानंतर तुमचे प्रीमियम सदस्यत्व तात्काळ सक्रिय होते. 
                        कधीकधी बँक प्रक्रियेसाठी 2-3 मिनिटे लागू शकतात.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question marathi-font" onclick="toggleFAQ(this)">
                        मी प्रीमियम सदस्यत्व रद्द करू शकतो का?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer marathi-font">
                        होय, तुम्ही कोणत्याही वेळी प्रीमियम सदस्यत्व रद्द करू शकता. 
                        परंतु रीफंंड फक्त 24 तासांच्या आतच शक्य आहे.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question marathi-font" onclick="toggleFAQ(this)">
                        प्रीमियम निवडल्यानंतर माझे प्रोफाइल कसे बदलेल?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer marathi-font">
                        तुमचे प्रोफाइल प्रीमियम बॅजसह दिसेल, शोध परिणामांमध्ये वरच्या क्रमांकावर दिसेल, 
                        आणि तुम्हाला अमर्यादित संदेश पाठवण्याची परवानगी मिळेल.
                    </div>
                </div>
            </div>

            <!-- Back to Dashboard -->
            <div class="text-center mt-5">
                <asp:Button ID="btnBackToDashboard" runat="server" Text="← डॅशबोर्डवर परत जा" 
                    CssClass="btn btn-secondary marathi-font px-5 py-3" 
                    style="font-size: 1.1rem; border-radius: 15px; background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%); border: 1px solid rgba(255,255,255,0.3);" 
                    OnClick="btnBackToDashboard_Click" />
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="border-radius: 25px; overflow: hidden; border: none;">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-bottom: none; padding: 30px;">
                    <h5 class="modal-title marathi-font" id="paymentModalTitle" style="font-size: 1.5rem;">पेमेंट पूर्ण करा</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 30px; background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);">
                    <asp:Panel ID="pnlPaymentForm" runat="server">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-4">
                                    <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">🎯 निवडलेली योजना</label>
                                    <asp:TextBox ID="txtSelectedPlan" runat="server" CssClass="form-control" 
                                        style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);" 
                                        ReadOnly="true"></asp:TextBox>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">💰 एकूण रक्कम</label>
                                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" 
                                        style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8); font-weight: bold; color: #28a745;" 
                                        ReadOnly="true"></asp:TextBox>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">⏰ कालावधी</label>
                                    <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" 
                                        style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);" 
                                        ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-4">
                                    <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">💳 पेमेंट पद्धत</label>
                                    <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control"
                                        style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);">
                                        <asp:ListItem Value="credit_card">क्रेडिट कार्ड</asp:ListItem>
                                        <asp:ListItem Value="debit_card">डेबिट कार्ड</asp:ListItem>
                                        <asp:ListItem Value="upi">UPI</asp:ListItem>
                                        <asp:ListItem Value="net_banking">नेट बँकिंग</asp:ListItem>
                                        <asp:ListItem Value="wallet">डिजिटल वॉलेट</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">🔢 कार्ड क्रमांक</label>
                                    <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" 
                                        placeholder="1234 5678 9012 3456" MaxLength="19"
                                        style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);"></asp:TextBox>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-4">
                                            <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">📅 समाप्ती तारीख</label>
                                            <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control" 
                                                placeholder="MM/YY" MaxLength="5"
                                                style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-4">
                                            <label class="form-label marathi-font" style="font-weight: 600; color: #2c3e50;">🔐 CVV</label>
                                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" 
                                                placeholder="123" MaxLength="3" TextMode="Password"
                                                style="border-radius: 12px; padding: 12px; border: 2px solid #e9ecef; background: rgba(255,255,255,0.8);"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-check mb-4">
                            <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" 
                                style="width: 20px; height: 20px; margin-top: 0.2rem;" />
                            <label class="form-check-label marathi-font" style="font-size: 0.95rem; line-height: 1.4;">
                                मी <a href="Terms.aspx" target="_blank" style="color: #667eea; text-decoration: none; font-weight: 600;">सेवा अटी</a> आणि 
                                <a href="Privacy.aspx" target="_blank" style="color: #667eea; text-decoration: none; font-weight: 600;">गोपनीयता धोरण</a> 
                                यांच्याशी सहमत आहे
                            </label>
                        </div>
                    </asp:Panel>
                </div>
                <div class="modal-footer" style="border-top: none; padding: 25px 30px; background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);">
                    <button type="button" class="btn btn-secondary marathi-font px-4 py-2" 
                        style="border-radius: 12px; background: linear-gradient(135deg, #6c757d 0%, #495057 100%); border: none;"
                        data-bs-dismiss="modal">रद्द करा</button>
                    <asp:Button ID="btnProcessPayment" runat="server" Text="💳 पेमेंट पूर्ण करा" 
                        CssClass="btn btn-success marathi-font px-4 py-2" 
                        style="border-radius: 12px; background: linear-gradient(135deg, #28a745 0%, #20c997 100%); border: none; font-weight: 600;"
                        OnClick="btnProcessPayment_Click" />
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    
    <script>
        // Toggle FAQ items
        function toggleFAQ(element) {
            const faqItem = element.parentElement;
            faqItem.classList.toggle('active');

            const icon = element.querySelector('i');
            if (faqItem.classList.contains('active')) {
                icon.className = 'fas fa-chevron-up';
            } else {
                icon.className = 'fas fa-chevron-down';
            }
        }

        // Format card number
        document.getElementById('<%= txtCardNumber.ClientID %>')?.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ');
            if (formattedValue) {
                e.target.value = formattedValue;
            }
        });

        // Format expiry date
        document.getElementById('<%= txtExpiryDate.ClientID %>')?.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
        });

        // Show payment modal
        function showPaymentModal(planName, amount, duration) {
            document.getElementById('<%= txtSelectedPlan.ClientID %>').value = planName;
            document.getElementById('<%= txtAmount.ClientID %>').value = '₹' + amount;
            document.getElementById('<%= txtDuration.ClientID %>').value = duration;

            const modal = new bootstrap.Modal(document.getElementById('paymentModal'));
            modal.show();
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Add animations to plan cards
            const planCards = document.querySelectorAll('.plan-card');
            planCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(50px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 200);
            });

            // Add click effects to buttons
            const buttons = document.querySelectorAll('.btn-plan');
            buttons.forEach(btn => {
                btn.addEventListener('click', function () {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });

            // Add parallax effect to floating elements
            window.addEventListener('scroll', function () {
                const scrolled = window.pageYOffset;
                const parallax = document.querySelector('.membership-container::before');
                if (parallax) {
                    parallax.style.transform = `translateY(${scrolled * 0.5}px)`;
                }
            });
        });

        // Show success notification
        function showSuccess(message) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-success alert-dismissible fade show';
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                border-radius: 15px;
                border: none;
                box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
                backdrop-filter: blur(10px);
                background: linear-gradient(135deg, rgba(40, 167, 69, 0.9) 0%, rgba(32, 201, 151, 0.9) 100%);
                color: white;
                max-width: 400px;
            `;
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas fa-check-circle me-2" style="font-size: 1.2rem;"></i>
                    <strong class="marathi-font">✅ यशस्वी!</strong>
                </div>
                <div class="marathi-font mt-1">${message}</div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" style="filter: brightness(0) invert(1);"></button>
            `;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    notification.remove();
                }
            }, 5000);
        }

        // Show error notification
        function showError(message) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-danger alert-dismissible fade show';
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                border-radius: 15px;
                border: none;
                box-shadow: 0 10px 30px rgba(220, 53, 69, 0.3);
                backdrop-filter: blur(10px);
                background: linear-gradient(135deg, rgba(220, 53, 69, 0.9) 0%, rgba(232, 62, 140, 0.9) 100%);
                color: white;
                max-width: 400px;
            `;
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-circle me-2" style="font-size: 1.2rem;"></i>
                    <strong class="marathi-font">❌ त्रुटी!</strong>
                </div>
                <div class="marathi-font mt-1">${message}</div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" style="filter: brightness(0) invert(1);"></button>
            `;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    notification.remove();
                }
            }, 5000);
        }
    </script>
</asp:Content>
