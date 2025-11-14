
<%@ Page Title="Marathi Matrimony - Professional Registration" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Registrations.aspx.cs" Inherits="JivanBandhan4.Registrations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .progress-container {
            margin: 30px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 25px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        
        .progress-steps::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 5%;
            right: 5%;
            height: 4px;
            background: rgba(255,255,255,0.3);
            z-index: 1;
            border-radius: 2px;
        }
        
        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            flex: 1;
        }
        
        .step-number {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 8px;
            border: 3px solid white;
            color: white;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .step-active .step-number {
            background: #ff6b6b;
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(255,107,107,0.4);
        }
        
        .step-completed .step-number {
            background: #51cf66;
            transform: scale(1.05);
        }
        
        .step-text {
            font-size: 13px;
            text-align: center;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .step-active .step-text {
            color: white;
            font-weight: bold;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .form-section {
            display: none;
            animation: slideInUp 0.6s ease-out;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        
        .form-section.active {
            display: block;
        }
        
        @keyframes slideInUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        .section-title {
            color: #d63384;
            border-bottom: 3px solid #d63384;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: linear-gradient(90deg, #d63384, #ff6b6b);
            border-radius: 2px;
        }
        
        .photo-upload-area {
            border: 3px dashed #667eea;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            margin: 25px 0;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .photo-upload-area:hover {
            border-color: #ff6b6b;
            background: linear-gradient(135deg, #fff0f6 0%, #fff5f5 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255,107,107,0.15);
        }
        
        .preview-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 12px;
            margin: 8px;
            border: 3px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .preview-image:hover {
            transform: scale(1.05);
            border-color: #667eea;
        }
        
        .celebration {
            display: none;
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .confetti {
            position: fixed;
            width: 12px;
            height: 12px;
            animation: confetti-fall 3s linear forwards;
            border-radius: 50%;
        }
        
        @keyframes confetti-fall {
            0% { 
                transform: translateY(-100px) rotate(0deg) scale(1); 
                opacity: 1; 
            }
            100% { 
                transform: translateY(100vh) rotate(720deg) scale(0.5); 
                opacity: 0; 
            }
        }
        
        .btn-marathi {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border: none;
            color: white;
            padding: 14px 35px;
            border-radius: 50px;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-marathi:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.6);
            background: linear-gradient(135deg, #c22575 0%, #ff5252 100%);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
            padding: 14px 30px;
            border-radius: 50px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .required-field::after {
            content: " *";
            color: #ff6b6b;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            background: white;
            transform: translateY(-1px);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .info-card {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            border: 1px solid #e0e7ff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .feature-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin-bottom: 15px;
        }

        .photo-count-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ff6b6b;
            color: white;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .photo-preview-container {
            position: relative;
            display: inline-block;
            margin: 5px;
        }

        .remove-photo-btn {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff6b6b;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>

    <div class="container mt-4">
        <!-- Header Section -->
        <div class="text-center mb-5">
            <div class="info-card">
                <h1 class="marathi-font" style="color: #d63384; font-size: 3rem; margin-bottom: 10px;">Marathi Matrimony</h1>
                <p class="marathi-font text-muted" style="font-size: 1.2rem;">Find Your Ideal Partner - With Trust and Dedication</p>
            </div>
        </div>
        
        <!-- Progress Bar -->
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-step step-active" data-step="1">
                    <div class="step-number">1</div>
                    <div class="step-text marathi-font">Personal Information</div>
                </div>
                <div class="progress-step" data-step="2">
                    <div class="step-number">2</div>
                    <div class="step-text marathi-font">Religious Information</div>
                </div>
                <div class="progress-step" data-step="3">
                    <div class="step-number">3</div>
                    <div class="step-text marathi-font">Education and Career</div>
                </div>
                <div class="progress-step" data-step="4">
                    <div class="step-number">4</div>
                    <div class="step-text marathi-font">Family Information</div>
                </div>
                <div class="progress-step" data-step="5">
                    <div class="step-number">5</div>
                    <div class="step-text marathi-font">Partner Expectations</div>
                </div>
                <div class="progress-step" data-step="6">
                    <div class="step-number">6</div>
                    <div class="step-text marathi-font">Photos and Final</div>
                </div>
            </div>
        </div>

        <!-- Step 1: Personal Information -->
        <div id="step1" class="form-section active">
            <h3 class="section-title marathi-font">👤 Personal Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Who is this profile for?</label>
                        <asp:DropDownList ID="ddlProfileFor" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Self">For Self</asp:ListItem>
                            <asp:ListItem Value="Son">For Son</asp:ListItem>
                            <asp:ListItem Value="Daughter">For Daughter</asp:ListItem>
                            <asp:ListItem Value="Brother">For Brother</asp:ListItem>
                            <asp:ListItem Value="Sister">For Sister</asp:ListItem>
                            <asp:ListItem Value="Relative">For Relative</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Gender</label>
                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Date of Birth</label>
                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Height</label>
                        <asp:DropDownList ID="ddlHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="4'6&quot;">4'6"</asp:ListItem>
                            <asp:ListItem Value="4'7&quot;">4'7"</asp:ListItem>
                            <asp:ListItem Value="4'8&quot;">4'8"</asp:ListItem>
                            <asp:ListItem Value="4'9&quot;">4'9"</asp:ListItem>
                            <asp:ListItem Value="4'10&quot;">4'10"</asp:ListItem>
                            <asp:ListItem Value="4'11&quot;">4'11"</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                            <asp:ListItem Value="6'1&quot;">6'1"</asp:ListItem>
                            <asp:ListItem Value="6'2&quot;">6'2"</asp:ListItem>
                            <asp:ListItem Value="6'3&quot;">6'3"</asp:ListItem>
                            <asp:ListItem Value="6'4&quot;">6'4"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Weight (kg)</label>
                        <asp:DropDownList ID="ddlWeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="40">40 kg</asp:ListItem>
                            <asp:ListItem Value="45">45 kg</asp:ListItem>
                            <asp:ListItem Value="50">50 kg</asp:ListItem>
                            <asp:ListItem Value="55">55 kg</asp:ListItem>
                            <asp:ListItem Value="60">60 kg</asp:ListItem>
                            <asp:ListItem Value="65">65 kg</asp:ListItem>
                            <asp:ListItem Value="70">70 kg</asp:ListItem>
                            <asp:ListItem Value="75">75 kg</asp:ListItem>
                            <asp:ListItem Value="80">80 kg</asp:ListItem>
                            <asp:ListItem Value="85">85 kg</asp:ListItem>
                            <asp:ListItem Value="90">90 kg</asp:ListItem>
                            <asp:ListItem Value="95">95 kg</asp:ListItem>
                            <asp:ListItem Value="100">100 kg</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Blood Group</label>
                        <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="A+">A+</asp:ListItem>
                            <asp:ListItem Value="A-">A-</asp:ListItem>
                            <asp:ListItem Value="B+">B+</asp:ListItem>
                            <asp:ListItem Value="B-">B-</asp:ListItem>
                            <asp:ListItem Value="O+">O+</asp:ListItem>
                            <asp:ListItem Value="O-">O-</asp:ListItem>
                            <asp:ListItem Value="AB+">AB+</asp:ListItem>
                            <asp:ListItem Value="AB-">AB-</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Marital Status</label>
                        <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Unmarried">Unmarried</asp:ListItem>
                            <asp:ListItem Value="Married">Married</asp:ListItem>
                            <asp:ListItem Value="Divorced">Divorced</asp:ListItem>
                            <asp:ListItem Value="Widow/Widower">Widow/Widower</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Physical Status</label>
                        <asp:DropDownList ID="ddlPhysicalStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Normal">Normal</asp:ListItem>
                            <asp:ListItem Value="Physically Challenged">Physically Challenged</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Eating Habits</label>
                        <asp:DropDownList ID="ddlEatingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Vegetarian">Vegetarian</asp:ListItem>
                            <asp:ListItem Value="Non-Vegetarian">Non-Vegetarian</asp:ListItem>
                            <asp:ListItem Value="Eggitarian">Eggitarian</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Drinking Habits</label>
                        <asp:DropDownList ID="ddlDrinkingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Occasionally">Occasionally</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Smoking Habits</label>
                        <asp:DropDownList ID="ddlSmokingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Occasionally">Occasionally</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(2)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 2: Religious Information -->
        <div id="step2" class="form-section">
            <h3 class="section-title marathi-font">🕌 Religious Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Religion</label>
                        <asp:DropDownList ID="ddlReligion" runat="server" CssClass="form-control" onchange="toggleHinduFields()">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Islam">Islam</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Caste</label>
                        <asp:DropDownList ID="ddlCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maratha">Maratha</asp:ListItem>
                            <asp:ListItem Value="Kunbi">Kunbi</asp:ListItem>
                            <asp:ListItem Value="Brahmin">Brahmin</asp:ListItem>
                            <asp:ListItem Value="Dalit">Dalit</asp:ListItem>
                            <asp:ListItem Value="Vani">Vani</asp:ListItem>
                            <asp:ListItem Value="Tamboli">Tamboli</asp:ListItem>
                            <asp:ListItem Value="Sonar">Sonar</asp:ListItem>
                            <asp:ListItem Value="Mali">Mali</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                            <asp:ListItem Value="Agari">Agari</asp:ListItem>
                            <asp:ListItem Value="Chambhar">Chambhar</asp:ListItem>
                            <asp:ListItem Value="Dhangar">Dhangar</asp:ListItem>
                            <asp:ListItem Value="Gavli">Gavli</asp:ListItem>
                            <asp:ListItem Value="Lohar">Lohar</asp:ListItem>
                            <asp:ListItem Value="Sutar">Sutar</asp:ListItem>
                            <asp:ListItem Value="Shimpi">Shimpi</asp:ListItem>
                            <asp:ListItem Value="Nhavi">Nhavi</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Sub Caste</label>
                        <asp:DropDownList ID="ddlSubCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Deshastha">Deshastha</asp:ListItem>
                            <asp:ListItem Value="Konkanastha">Konkanastha</asp:ListItem>
                            <asp:ListItem Value="Chitpavan">Chitpavan</asp:ListItem>
                            <asp:ListItem Value="Karade">Karade</asp:ListItem>
                            <asp:ListItem Value="Saraswat">Saraswat</asp:ListItem>
                            <asp:ListItem Value="Daivajna">Daivajna</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group" id="gothraSection">
                        <label class="marathi-font form-label">Gothra</label>
                        <asp:DropDownList ID="ddlGothra" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Kashyap">Kashyap</asp:ListItem>
                            <asp:ListItem Value="Bharadwaj">Bharadwaj</asp:ListItem>
                            <asp:ListItem Value="Vats">Vats</asp:ListItem>
                            <asp:ListItem Value="Vishwamitra">Vishwamitra</asp:ListItem>
                            <asp:ListItem Value="Gautam">Gautam</asp:ListItem>
                            <asp:ListItem Value="Jamadagni">Jamadagni</asp:ListItem>
                            <asp:ListItem Value="Vashishtha">Vashishtha</asp:ListItem>
                            <asp:ListItem Value="Agastya">Agastya</asp:ListItem>
                            <asp:ListItem Value="Kaundinya">Kaundinya</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Manglik</label>
                        <asp:DropDownList ID="ddlManglik" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Not Sure">Not Sure</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Mother Tongue</label>
                        <asp:DropDownList ID="ddlMotherTongue" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Marathi">Marathi</asp:ListItem>
                            <asp:ListItem Value="Hindi">Hindi</asp:ListItem>
                            <asp:ListItem Value="English">English</asp:ListItem>
                            <asp:ListItem Value="Gujarati">Gujarati</asp:ListItem>
                            <asp:ListItem Value="Kannada">Kannada</asp:ListItem>
                            <asp:ListItem Value="Tamil">Tamil</asp:ListItem>
                            <asp:ListItem Value="Telugu">Telugu</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(1)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(3)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 3: Education & Career -->
        <div id="step3" class="form-section">
            <h3 class="section-title marathi-font">🎓 Education and Career</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Education</label>
                        <asp:DropDownList ID="ddlEducation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="10th">10th</asp:ListItem>
                            <asp:ListItem Value="12th">12th</asp:ListItem>
                            <asp:ListItem Value="B.A.">B.A.</asp:ListItem>
                            <asp:ListItem Value="B.Com">B.Com</asp:ListItem>
                            <asp:ListItem Value="B.Sc">B.Sc</asp:ListItem>
                            <asp:ListItem Value="B.E.">B.E.</asp:ListItem>
                            <asp:ListItem Value="M.B.A.">M.B.A.</asp:ListItem>
                            <asp:ListItem Value="M.A.">M.A.</asp:ListItem>
                            <asp:ListItem Value="M.Sc">M.Sc</asp:ListItem>
                            <asp:ListItem Value="C.A.">C.A.</asp:ListItem>
                            <asp:ListItem Value="Ph.D.">Ph.D.</asp:ListItem>
                            <asp:ListItem Value="Diploma">Diploma</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Education Field</label>
                        <asp:DropDownList ID="ddlEducationField" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Science">Science</asp:ListItem>
                            <asp:ListItem Value="Arts">Arts</asp:ListItem>
                            <asp:ListItem Value="Commerce">Commerce</asp:ListItem>
                            <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                            <asp:ListItem Value="Medical">Medical</asp:ListItem>
                            <asp:ListItem Value="Management">Management</asp:ListItem>
                            <asp:ListItem Value="Law">Law</asp:ListItem>
                            <asp:ListItem Value="Education">Education</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">College/University</label>
                        <asp:DropDownList ID="ddlCollege" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune University">Pune University</asp:ListItem>
                            <asp:ListItem Value="Mumbai University">Mumbai University</asp:ListItem>
                            <asp:ListItem Value="Savitribai Phule Pune University">Savitribai Phule Pune University</asp:ListItem>
                            <asp:ListItem Value="Shivaji University">Shivaji University</asp:ListItem>
                            <asp:ListItem Value="Solapur University">Solapur University</asp:ListItem>
                            <asp:ListItem Value="Nagpur University">Nagpur University</asp:ListItem>
                            <asp:ListItem Value="Swami Ramanand Teerth Marathwada University">Swami Ramanand Teerth Marathwada University</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Occupation</label>
                        <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                            <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                            <asp:ListItem Value="Housewife">Housewife</asp:ListItem>
                            <asp:ListItem Value="Looking for Job">Looking for Job</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Occupation Field</label>
                        <asp:DropDownList ID="ddlOccupationField" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="IT">IT</asp:ListItem>
                            <asp:ListItem Value="Banking">Banking</asp:ListItem>
                            <asp:ListItem Value="Education">Education</asp:ListItem>
                            <asp:ListItem Value="Medical">Medical</asp:ListItem>
                            <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                            <asp:ListItem Value="Government">Government</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Company</label>
                        <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Tata">Tata</asp:ListItem>
                            <asp:ListItem Value="Infosys">Infosys</asp:ListItem>
                            <asp:ListItem Value="TCS">TCS</asp:ListItem>
                            <asp:ListItem Value="Wipro">Wipro</asp:ListItem>
                            <asp:ListItem Value="Mahindra">Mahindra</asp:ListItem>
                            <asp:ListItem Value="State Bank">State Bank</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Annual Income (Rupees)</label>
                        <asp:DropDownList ID="ddlIncome" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">None</asp:ListItem>
                            <asp:ListItem Value="100000">Less than 1 Lakh</asp:ListItem>
                            <asp:ListItem Value="200000">1-2 Lakhs</asp:ListItem>
                            <asp:ListItem Value="500000">2-5 Lakhs</asp:ListItem>
                            <asp:ListItem Value="1000000">5-10 Lakhs</asp:ListItem>
                            <asp:ListItem Value="2000000">10-20 Lakhs</asp:ListItem>
                            <asp:ListItem Value="5000000">More than 20 Lakhs</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Work Location</label>
                        <asp:DropDownList ID="ddlWorkingLocation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(2)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(4)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 4: Family Background -->
        <div id="step4" class="form-section">
            <h3 class="section-title marathi-font">👨‍👩‍👧‍👦 Family Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Family Type</label>
                        <asp:DropDownList ID="ddlFamilyType" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Joint Family">Joint Family</asp:ListItem>
                            <asp:ListItem Value="Nuclear Family">Nuclear Family</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Family Status</label>
                        <asp:DropDownList ID="ddlFamilyStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Middle Class">Middle Class</asp:ListItem>
                            <asp:ListItem Value="Upper Middle Class">Upper Middle Class</asp:ListItem>
                            <asp:ListItem Value="Rich">Rich</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Father's Occupation</label>
                        <asp:DropDownList ID="ddlFatherOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Farmer">Farmer</asp:ListItem>
                            <asp:ListItem Value="Retired">Retired</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Mother's Occupation</label>
                        <asp:DropDownList ID="ddlMotherOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Housewife">Housewife</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Retired">Retired</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Number of Brothers</label>
                        <asp:DropDownList ID="ddlNoOfBrothers" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">0</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                            <asp:ListItem Value="4">4</asp:ListItem>
                            <asp:ListItem Value="5">More than 5</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Number of Sisters</label>
                        <asp:DropDownList ID="ddlNoOfSisters" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">0</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                            <asp:ListItem Value="4">4</asp:ListItem>
                            <asp:ListItem Value="5">More than 5</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Native Place</label>
                        <asp:DropDownList ID="ddlNativePlace" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">More about Family</label>
                <asp:TextBox ID="txtFamilyDetails" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="More about family..."></asp:TextBox>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(3)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(5)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 5: Partner Expectations -->
        <div id="step5" class="form-section">
            <h3 class="section-title marathi-font">💑 Partner Expectations</h3>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Age (Minimum)</label>
                        <asp:DropDownList ID="ddlMinAge" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="18">18</asp:ListItem>
                            <asp:ListItem Value="20">20</asp:ListItem>
                            <asp:ListItem Value="22">22</asp:ListItem>
                            <asp:ListItem Value="24">24</asp:ListItem>
                            <asp:ListItem Value="26">26</asp:ListItem>
                            <asp:ListItem Value="28">28</asp:ListItem>
                            <asp:ListItem Value="30">30</asp:ListItem>
                            <asp:ListItem Value="32">32</asp:ListItem>
                            <asp:ListItem Value="34">34</asp:ListItem>
                            <asp:ListItem Value="36">36</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Age (Maximum)</label>
                        <asp:DropDownList ID="ddlMaxAge" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="25">25</asp:ListItem>
                            <asp:ListItem Value="27">27</asp:ListItem>
                            <asp:ListItem Value="29">29</asp:ListItem>
                            <asp:ListItem Value="31">31</asp:ListItem>
                            <asp:ListItem Value="33">33</asp:ListItem>
                            <asp:ListItem Value="35">35</asp:ListItem>
                            <asp:ListItem Value="37">37</asp:ListItem>
                            <asp:ListItem Value="39">39</asp:ListItem>
                            <asp:ListItem Value="41">41</asp:ListItem>
                            <asp:ListItem Value="43">43</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Minimum Height</label>
                        <asp:DropDownList ID="ddlMinHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="4'6&quot;">4'6"</asp:ListItem>
                            <asp:ListItem Value="4'7&quot;">4'7"</asp:ListItem>
                            <asp:ListItem Value="4'8&quot;">4'8"</asp:ListItem>
                            <asp:ListItem Value="4'9&quot;">4'9"</asp:ListItem>
                            <asp:ListItem Value="4'10&quot;">4'10"</asp:ListItem>
                            <asp:ListItem Value="4'11&quot;">4'11"</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Maximum Height</label>
                        <asp:DropDownList ID="ddlMaxHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                            <asp:ListItem Value="6'1&quot;">6'1"</asp:ListItem>
                            <asp:ListItem Value="6'2&quot;">6'2"</asp:ListItem>
                            <asp:ListItem Value="6'3&quot;">6'3"</asp:ListItem>
                            <asp:ListItem Value="6'4&quot;">6'4"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Religion</label>
                        <asp:DropDownList ID="ddlPreferredReligion" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Islam">Islam</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Caste</label>
                        <asp:DropDownList ID="ddlPreferredCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maratha">Maratha</asp:ListItem>
                            <asp:ListItem Value="Kunbi">Kunbi</asp:ListItem>
                            <asp:ListItem Value="Brahmin">Brahmin</asp:ListItem>
                            <asp:ListItem Value="Dalit">Dalit</asp:ListItem>
                            <asp:ListItem Value="Vani">Vani</asp:ListItem>
                            <asp:ListItem Value="Tamboli">Tamboli</asp:ListItem>
                            <asp:ListItem Value="Sonar">Sonar</asp:ListItem>
                            <asp:ListItem Value="Mali">Mali</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                            <asp:ListItem Value="Agari">Agari</asp:ListItem>
                            <asp:ListItem Value="Chambhar">Chambhar</asp:ListItem>
                            <asp:ListItem Value="Dhangar">Dhangar</asp:ListItem>
                            <asp:ListItem Value="Gavli">Gavli</asp:ListItem>
                            <asp:ListItem Value="Lohar">Lohar</asp:ListItem>
                            <asp:ListItem Value="Sutar">Sutar</asp:ListItem>
                            <asp:ListItem Value="Shimpi">Shimpi</asp:ListItem>
                            <asp:ListItem Value="Nhavi">Nhavi</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Education</label>
                        <asp:DropDownList ID="ddlPreferredEducation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                            <asp:ListItem Value="10th">10th</asp:ListItem>
                            <asp:ListItem Value="12th">12th</asp:ListItem>
                            <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                            <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="MBA">MBA</asp:ListItem>
                            <asp:ListItem Value="CA">CA</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Occupation</label>
                        <asp:DropDownList ID="ddlPreferredOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                            <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">Partner Expectations (Detailed)</label>
                <asp:TextBox ID="txtPartnerExpectations" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="Write in detail about your ideal partner..."></asp:TextBox>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(4)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(6)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 6: Photo Upload & Final -->
        <div id="step6" class="form-section">
            <h3 class="section-title marathi-font">📸 Photos and Final Information</h3>
            
            <!-- Login Information -->
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Confirm Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Mobile Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" TextMode="Phone" placeholder="Your mobile number"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Location Information -->
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">State</label>
                        <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maharashtra">Maharashtra</asp:ListItem>
                            <asp:ListItem Value="Karnataka">Karnataka</asp:ListItem>
                            <asp:ListItem Value="Gujarat">Gujarat</asp:ListItem>
                            <asp:ListItem Value="Madhya Pradesh">Madhya Pradesh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">District</label>
                        <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">City</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Profile Photo Upload -->
            <div class="photo-upload-area" onclick="document.getElementById('<%= fuProfilePhoto.ClientID %>').click()">
                <div class="feature-icon">
                    <i class="fas fa-camera"></i>
                </div>
                <h5 class="marathi-font">📷 Profile Photo *</h5>
                <p class="text-muted marathi-font">Please upload a clear and recent profile photo</p>
                <asp:FileUpload ID="fuProfilePhoto" runat="server" CssClass="form-control-file d-none" accept="image/*" />
                <div id="profilePreview" class="mt-3"></div>
            </div>

            <!-- Additional Photos Upload -->
            <div class="photo-upload-area" onclick="document.getElementById('<%= fuAdditionalPhotos.ClientID %>').click()">
                <div class="feature-icon">
                    <i class="fas fa-images"></i>
                </div>
                <h5 class="marathi-font">🖼️ Additional Photos (up to 5)</h5>
                <p class="text-muted marathi-font">Upload your additional photos (maximum 5 photos)</p>
                <asp:FileUpload ID="fuAdditionalPhotos" runat="server" CssClass="form-control-file d-none" 
                    accept="image/*" multiple="multiple" />
                <div id="additionalPhotosPreview" class="mt-3 d-flex flex-wrap"></div>
            </div>

            <!-- About Me -->
            <div class="form-group">
                <label class="marathi-font form-label">About Me</label>
                <asp:TextBox ID="txtAboutMe" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="Write briefly about yourself..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">Hobbies, Interests</label>
                <asp:TextBox ID="txtHobbies" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" 
                    placeholder="Write about your hobbies and interests..."></asp:TextBox>
            </div>

            <div class="alert alert-info marathi-font" style="border-radius: 12px; border-left: 4px solid #667eea;">
                <strong>📝 Note:</strong> Ensure all information is accurate and true. Upload only clear and recent photos.
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(5)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <asp:Button ID="btnSubmit" runat="server" Text="Complete Registration 🎉" CssClass="btn btn-marathi marathi-font" 
                    OnClick="btnSubmit_Click" />
            </div>
        </div>

        <!-- Celebration Animation -->
        <div id="celebration" class="celebration">
            <div class="text-center">
                <div class="feature-icon" style="margin: 0 auto 20px; background: rgba(255,255,255,0.2);">
                    <i class="fas fa-heart" style="font-size: 24px;"></i>
                </div>
                <h1 class="marathi-font" style="font-size: 3rem; margin-bottom: 20px;">🎉 Congratulations! 🎉</h1>
                <h3 class="marathi-font" style="margin-bottom: 20px;">Your Marathi Matrimony registration has been completed successfully!</h3>
                <p class="marathi-font">A confirmation message has been sent to your email.</p>
                <p class="marathi-font">You can now start searching for your ideal partner.</p>
                <div class="mt-4">
                    <a href="Login.aspx" class="btn btn-marathi marathi-font">Login</a>
                    <a href="BrowseProfiles.aspx" class="btn btn-outline-light marathi-font ml-2">Browse Profiles</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentStep = 1;
        let additionalPhotos = [];

        function nextStep(step) {
            if (validateStep(currentStep)) {
                document.getElementById('step' + currentStep).classList.remove('active');
                document.getElementById('step' + step).classList.add('active');
                updateProgressBar(currentStep, step);
                currentStep = step;

                // Scroll to top of page
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }

        function prevStep(step) {
            document.getElementById('step' + currentStep).classList.remove('active');
            document.getElementById('step' + step).classList.add('active');
            updateProgressBar(currentStep, step);
            currentStep = step;

            // Scroll to top of page
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function updateProgressBar(fromStep, toStep) {
            const steps = document.querySelectorAll('.progress-step');
            steps.forEach(step => {
                const stepNum = parseInt(step.getAttribute('data-step'));
                step.classList.remove('step-active', 'step-completed');

                if (stepNum === toStep) {
                    step.classList.add('step-active');
                } else if (stepNum < toStep) {
                    step.classList.add('step-completed');
                }
            });
        }

        function validateStep(step) {
            // Add validation logic for each step
            // Return true if valid, false otherwise
            return true;
        }

        function toggleHinduFields() {
            var religion = document.getElementById('<%= ddlReligion.ClientID %>');
            var gothraSection = document.getElementById('gothraSection');
            
            if (religion.value === 'Hindu') {
                gothraSection.style.display = 'block';
            } else {
                gothraSection.style.display = 'block';
            }
        }

        function showCelebration() {
            document.querySelectorAll('.form-section').forEach(section => {
                section.style.display = 'none';
            });
            document.getElementById('celebration').style.display = 'block';
            createConfetti();
        }

        function createConfetti() {
            const colors = ['#ff6b6b', '#51cf66', '#339af0', '#fcc419', '#cc5de8', '#20c997'];
            for (let i = 0; i < 150; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDelay = Math.random() * 2 + 's';
                confetti.style.width = Math.random() * 10 + 8 + 'px';
                confetti.style.height = Math.random() * 10 + 8 + 'px';
                document.body.appendChild(confetti);

                setTimeout(() => {
                    confetti.remove();
                }, 3000);
            }
        }

        // Profile photo preview functionality
        document.getElementById('<%= fuProfilePhoto.ClientID %>').addEventListener('change', function (e) {
            previewImage(e.target.files[0], 'profilePreview');
        });

        // Additional photos preview functionality
        document.getElementById('<%= fuAdditionalPhotos.ClientID %>').addEventListener('change', function (e) {
            previewMultipleImages(e.target.files, 'additionalPhotosPreview');
        });

        function previewImage(file, previewId) {
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'preview-image';
                    document.getElementById(previewId).innerHTML = '';
                    document.getElementById(previewId).appendChild(img);
                }
                reader.readAsDataURL(file);
            }
        }

        function previewMultipleImages(files, previewId) {
            const previewContainer = document.getElementById(previewId);

            if (files) {
                const fileArray = Array.from(files);

                // Limit to 5 files
                if (fileArray.length > 5) {
                    alert('You can only upload 5 photos');
                    return;
                }

                fileArray.forEach((file, index) => {
                    if (index >= 5) return;

                    if (file.type.match('image.*')) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            const imgContainer = document.createElement('div');
                            imgContainer.className = 'photo-preview-container';

                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'preview-image';
                            img.style.width = '100px';
                            img.style.height = '100px';

                            const removeBtn = document.createElement('button');
                            removeBtn.type = 'button';
                            removeBtn.className = 'remove-photo-btn';
                            removeBtn.innerHTML = '×';
                            removeBtn.onclick = function () {
                                imgContainer.remove();
                                updateFileInput(file);
                            };

                            imgContainer.appendChild(img);
                            imgContainer.appendChild(removeBtn);
                            previewContainer.appendChild(imgContainer);
                        }
                        reader.readAsDataURL(file);
                    }
                });
            }
        }

        function updateFileInput(fileToRemove) {
            // This is a simplified version - in production you might want to implement
            // a more complex solution to manage the file input
            console.log('File removal would require more complex implementation');
        }

        // View Profile - Redirect to ViewProfile page
        function viewProfile(userID) {
            console.log('Navigating to profile:', userID);
            window.location.href = 'ViewProfile.aspx?UserID=' + userID;
        }

        // Initialize on page load
        window.onload = function () {
            toggleHinduFields();
        };
    </script>
</asp:Content>





















<%--


<%@ Page Title="Marathi Matrimony - Professional Registration" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Registrations.aspx.cs" Inherits="JivanBandhan4.Registrations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .progress-container {
            margin: 30px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 25px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        
        .progress-steps::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 5%;
            right: 5%;
            height: 4px;
            background: rgba(255,255,255,0.3);
            z-index: 1;
            border-radius: 2px;
        }
        
        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            flex: 1;
        }
        
        .step-number {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 8px;
            border: 3px solid white;
            color: white;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .step-active .step-number {
            background: #ff6b6b;
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(255,107,107,0.4);
        }
        
        .step-completed .step-number {
            background: #51cf66;
            transform: scale(1.05);
        }
        
        .step-text {
            font-size: 13px;
            text-align: center;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .step-active .step-text {
            color: white;
            font-weight: bold;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .form-section {
            display: none;
            animation: slideInUp 0.6s ease-out;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        
        .form-section.active {
            display: block;
        }
        
        @keyframes slideInUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        .section-title {
            color: #d63384;
            border-bottom: 3px solid #d63384;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: linear-gradient(90deg, #d63384, #ff6b6b);
            border-radius: 2px;
        }
        
        .photo-upload-area {
            border: 3px dashed #667eea;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            margin: 25px 0;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .photo-upload-area:hover {
            border-color: #ff6b6b;
            background: linear-gradient(135deg, #fff0f6 0%, #fff5f5 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255,107,107,0.15);
        }
        
        .preview-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 12px;
            margin: 8px;
            border: 3px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .preview-image:hover {
            transform: scale(1.05);
            border-color: #667eea;
        }
        
        .celebration {
            display: none;
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .confetti {
            position: fixed;
            width: 12px;
            height: 12px;
            animation: confetti-fall 3s linear forwards;
            border-radius: 50%;
        }
        
        @keyframes confetti-fall {
            0% { 
                transform: translateY(-100px) rotate(0deg) scale(1); 
                opacity: 1; 
            }
            100% { 
                transform: translateY(100vh) rotate(720deg) scale(0.5); 
                opacity: 0; 
            }
        }
        
        .btn-marathi {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border: none;
            color: white;
            padding: 14px 35px;
            border-radius: 50px;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-marathi:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.6);
            background: linear-gradient(135deg, #c22575 0%, #ff5252 100%);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
            padding: 14px 30px;
            border-radius: 50px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .required-field::after {
            content: " *";
            color: #ff6b6b;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            background: white;
            transform: translateY(-1px);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .info-card {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            border: 1px solid #e0e7ff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .feature-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin-bottom: 15px;
        }

        .photo-count-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ff6b6b;
            color: white;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .photo-preview-container {
            position: relative;
            display: inline-block;
            margin: 5px;
        }

        .remove-photo-btn {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff6b6b;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>

    <div class="container mt-4">
        <!-- Header Section -->
        <div class="text-center mb-5">
            <div class="info-card">
                <h1 class="marathi-font" style="color: #d63384; font-size: 3rem; margin-bottom: 10px;">Marathi Matrimony</h1>
                <p class="marathi-font text-muted" style="font-size: 1.2rem;">Find Your Ideal Partner - With Trust and Dedication</p>
            </div>
        </div>
        
        <!-- Progress Bar -->
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-step step-active" data-step="1">
                    <div class="step-number">1</div>
                    <div class="step-text marathi-font">Personal Information</div>
                </div>
                <div class="progress-step" data-step="2">
                    <div class="step-number">2</div>
                    <div class="step-text marathi-font">Religious Information</div>
                </div>
                <div class="progress-step" data-step="3">
                    <div class="step-number">3</div>
                    <div class="step-text marathi-font">Education and Career</div>
                </div>
                <div class="progress-step" data-step="4">
                    <div class="step-number">4</div>
                    <div class="step-text marathi-font">Family Information</div>
                </div>
                <div class="progress-step" data-step="5">
                    <div class="step-number">5</div>
                    <div class="step-text marathi-font">Partner Expectations</div>
                </div>
                <div class="progress-step" data-step="6">
                    <div class="step-number">6</div>
                    <div class="step-text marathi-font">Photos and Final</div>
                </div>
            </div>
        </div>

        <!-- Step 1: Personal Information -->
        <div id="step1" class="form-section active">
            <h3 class="section-title marathi-font">👤 Personal Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Who is this profile for?</label>
                        <asp:DropDownList ID="ddlProfileFor" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Self">For Self</asp:ListItem>
                            <asp:ListItem Value="Son">For Son</asp:ListItem>
                            <asp:ListItem Value="Daughter">For Daughter</asp:ListItem>
                            <asp:ListItem Value="Brother">For Brother</asp:ListItem>
                            <asp:ListItem Value="Sister">For Sister</asp:ListItem>
                            <asp:ListItem Value="Relative">For Relative</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Gender</label>
                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Date of Birth</label>
                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Height</label>
                        <asp:DropDownList ID="ddlHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="4'6&quot;">4'6"</asp:ListItem>
                            <asp:ListItem Value="4'7&quot;">4'7"</asp:ListItem>
                            <asp:ListItem Value="4'8&quot;">4'8"</asp:ListItem>
                            <asp:ListItem Value="4'9&quot;">4'9"</asp:ListItem>
                            <asp:ListItem Value="4'10&quot;">4'10"</asp:ListItem>
                            <asp:ListItem Value="4'11&quot;">4'11"</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                            <asp:ListItem Value="6'1&quot;">6'1"</asp:ListItem>
                            <asp:ListItem Value="6'2&quot;">6'2"</asp:ListItem>
                            <asp:ListItem Value="6'3&quot;">6'3"</asp:ListItem>
                            <asp:ListItem Value="6'4&quot;">6'4"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Weight (kg)</label>
                        <asp:DropDownList ID="ddlWeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="40">40 kg</asp:ListItem>
                            <asp:ListItem Value="45">45 kg</asp:ListItem>
                            <asp:ListItem Value="50">50 kg</asp:ListItem>
                            <asp:ListItem Value="55">55 kg</asp:ListItem>
                            <asp:ListItem Value="60">60 kg</asp:ListItem>
                            <asp:ListItem Value="65">65 kg</asp:ListItem>
                            <asp:ListItem Value="70">70 kg</asp:ListItem>
                            <asp:ListItem Value="75">75 kg</asp:ListItem>
                            <asp:ListItem Value="80">80 kg</asp:ListItem>
                            <asp:ListItem Value="85">85 kg</asp:ListItem>
                            <asp:ListItem Value="90">90 kg</asp:ListItem>
                            <asp:ListItem Value="95">95 kg</asp:ListItem>
                            <asp:ListItem Value="100">100 kg</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Blood Group</label>
                        <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="A+">A+</asp:ListItem>
                            <asp:ListItem Value="A-">A-</asp:ListItem>
                            <asp:ListItem Value="B+">B+</asp:ListItem>
                            <asp:ListItem Value="B-">B-</asp:ListItem>
                            <asp:ListItem Value="O+">O+</asp:ListItem>
                            <asp:ListItem Value="O-">O-</asp:ListItem>
                            <asp:ListItem Value="AB+">AB+</asp:ListItem>
                            <asp:ListItem Value="AB-">AB-</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Marital Status</label>
                        <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Unmarried">Unmarried</asp:ListItem>
                            <asp:ListItem Value="Married">Married</asp:ListItem>
                            <asp:ListItem Value="Divorced">Divorced</asp:ListItem>
                            <asp:ListItem Value="Widow/Widower">Widow/Widower</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Physical Status</label>
                        <asp:DropDownList ID="ddlPhysicalStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Normal">Normal</asp:ListItem>
                            <asp:ListItem Value="Physically Challenged">Physically Challenged</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Eating Habits</label>
                        <asp:DropDownList ID="ddlEatingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Vegetarian">Vegetarian</asp:ListItem>
                            <asp:ListItem Value="Non-Vegetarian">Non-Vegetarian</asp:ListItem>
                            <asp:ListItem Value="Eggitarian">Eggitarian</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Drinking Habits</label>
                        <asp:DropDownList ID="ddlDrinkingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Occasionally">Occasionally</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Smoking Habits</label>
                        <asp:DropDownList ID="ddlSmokingHabits" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Occasionally">Occasionally</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(2)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 2: Religious Information -->
        <div id="step2" class="form-section">
            <h3 class="section-title marathi-font">🕌 Religious Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Religion</label>
                        <asp:DropDownList ID="ddlReligion" runat="server" CssClass="form-control" onchange="toggleHinduFields()">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Islam">Islam</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Caste</label>
                        <asp:DropDownList ID="ddlCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maratha">Maratha</asp:ListItem>
                            <asp:ListItem Value="Kunbi">Kunbi</asp:ListItem>
                            <asp:ListItem Value="Brahmin">Brahmin</asp:ListItem>
                            <asp:ListItem Value="Dalit">Dalit</asp:ListItem>
                            <asp:ListItem Value="Vani">Vani</asp:ListItem>
                            <asp:ListItem Value="Tamboli">Tamboli</asp:ListItem>
                            <asp:ListItem Value="Sonar">Sonar</asp:ListItem>
                            <asp:ListItem Value="Mali">Mali</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                            <asp:ListItem Value="Agari">Agari</asp:ListItem>
                            <asp:ListItem Value="Chambhar">Chambhar</asp:ListItem>
                            <asp:ListItem Value="Dhangar">Dhangar</asp:ListItem>
                            <asp:ListItem Value="Gavli">Gavli</asp:ListItem>
                            <asp:ListItem Value="Lohar">Lohar</asp:ListItem>
                            <asp:ListItem Value="Sutar">Sutar</asp:ListItem>
                            <asp:ListItem Value="Shimpi">Shimpi</asp:ListItem>
                            <asp:ListItem Value="Nhavi">Nhavi</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Sub Caste</label>
                        <asp:DropDownList ID="ddlSubCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Deshastha">Deshastha</asp:ListItem>
                            <asp:ListItem Value="Konkanastha">Konkanastha</asp:ListItem>
                            <asp:ListItem Value="Chitpavan">Chitpavan</asp:ListItem>
                            <asp:ListItem Value="Karade">Karade</asp:ListItem>
                            <asp:ListItem Value="Saraswat">Saraswat</asp:ListItem>
                            <asp:ListItem Value="Daivajna">Daivajna</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group" id="gothraSection">
                        <label class="marathi-font form-label">Gothra</label>
                        <asp:DropDownList ID="ddlGothra" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Kashyap">Kashyap</asp:ListItem>
                            <asp:ListItem Value="Bharadwaj">Bharadwaj</asp:ListItem>
                            <asp:ListItem Value="Vats">Vats</asp:ListItem>
                            <asp:ListItem Value="Vishwamitra">Vishwamitra</asp:ListItem>
                            <asp:ListItem Value="Gautam">Gautam</asp:ListItem>
                            <asp:ListItem Value="Jamadagni">Jamadagni</asp:ListItem>
                            <asp:ListItem Value="Vashishtha">Vashishtha</asp:ListItem>
                            <asp:ListItem Value="Agastya">Agastya</asp:ListItem>
                            <asp:ListItem Value="Kaundinya">Kaundinya</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Manglik</label>
                        <asp:DropDownList ID="ddlManglik" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                            <asp:ListItem Value="Not Sure">Not Sure</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Mother Tongue</label>
                        <asp:DropDownList ID="ddlMotherTongue" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Marathi">Marathi</asp:ListItem>
                            <asp:ListItem Value="Hindi">Hindi</asp:ListItem>
                            <asp:ListItem Value="English">English</asp:ListItem>
                            <asp:ListItem Value="Gujarati">Gujarati</asp:ListItem>
                            <asp:ListItem Value="Kannada">Kannada</asp:ListItem>
                            <asp:ListItem Value="Tamil">Tamil</asp:ListItem>
                            <asp:ListItem Value="Telugu">Telugu</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(1)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(3)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 3: Education & Career -->
        <div id="step3" class="form-section">
            <h3 class="section-title marathi-font">🎓 Education and Career</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Education</label>
                        <asp:DropDownList ID="ddlEducation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="10th">10th</asp:ListItem>
                            <asp:ListItem Value="12th">12th</asp:ListItem>
                            <asp:ListItem Value="B.A.">B.A.</asp:ListItem>
                            <asp:ListItem Value="B.Com">B.Com</asp:ListItem>
                            <asp:ListItem Value="B.Sc">B.Sc</asp:ListItem>
                            <asp:ListItem Value="B.E.">B.E.</asp:ListItem>
                            <asp:ListItem Value="M.B.A.">M.B.A.</asp:ListItem>
                            <asp:ListItem Value="M.A.">M.A.</asp:ListItem>
                            <asp:ListItem Value="M.Sc">M.Sc</asp:ListItem>
                            <asp:ListItem Value="C.A.">C.A.</asp:ListItem>
                            <asp:ListItem Value="Ph.D.">Ph.D.</asp:ListItem>
                            <asp:ListItem Value="Diploma">Diploma</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Education Field</label>
                        <asp:DropDownList ID="ddlEducationField" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Science">Science</asp:ListItem>
                            <asp:ListItem Value="Arts">Arts</asp:ListItem>
                            <asp:ListItem Value="Commerce">Commerce</asp:ListItem>
                            <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                            <asp:ListItem Value="Medical">Medical</asp:ListItem>
                            <asp:ListItem Value="Management">Management</asp:ListItem>
                            <asp:ListItem Value="Law">Law</asp:ListItem>
                            <asp:ListItem Value="Education">Education</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">College/University</label>
                        <asp:DropDownList ID="ddlCollege" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune University">Pune University</asp:ListItem>
                            <asp:ListItem Value="Mumbai University">Mumbai University</asp:ListItem>
                            <asp:ListItem Value="Savitribai Phule Pune University">Savitribai Phule Pune University</asp:ListItem>
                            <asp:ListItem Value="Shivaji University">Shivaji University</asp:ListItem>
                            <asp:ListItem Value="Solapur University">Solapur University</asp:ListItem>
                            <asp:ListItem Value="Nagpur University">Nagpur University</asp:ListItem>
                            <asp:ListItem Value="Swami Ramanand Teerth Marathwada University">Swami Ramanand Teerth Marathwada University</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Occupation</label>
                        <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                            <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                            <asp:ListItem Value="Housewife">Housewife</asp:ListItem>
                            <asp:ListItem Value="Looking for Job">Looking for Job</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Occupation Field</label>
                        <asp:DropDownList ID="ddlOccupationField" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="IT">IT</asp:ListItem>
                            <asp:ListItem Value="Banking">Banking</asp:ListItem>
                            <asp:ListItem Value="Education">Education</asp:ListItem>
                            <asp:ListItem Value="Medical">Medical</asp:ListItem>
                            <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                            <asp:ListItem Value="Government">Government</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Company</label>
                        <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Tata">Tata</asp:ListItem>
                            <asp:ListItem Value="Infosys">Infosys</asp:ListItem>
                            <asp:ListItem Value="TCS">TCS</asp:ListItem>
                            <asp:ListItem Value="Wipro">Wipro</asp:ListItem>
                            <asp:ListItem Value="Mahindra">Mahindra</asp:ListItem>
                            <asp:ListItem Value="State Bank">State Bank</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Annual Income (Rupees)</label>
                        <asp:DropDownList ID="ddlIncome" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">None</asp:ListItem>
                            <asp:ListItem Value="100000">Less than 1 Lakh</asp:ListItem>
                            <asp:ListItem Value="200000">1-2 Lakhs</asp:ListItem>
                            <asp:ListItem Value="500000">2-5 Lakhs</asp:ListItem>
                            <asp:ListItem Value="1000000">5-10 Lakhs</asp:ListItem>
                            <asp:ListItem Value="2000000">10-20 Lakhs</asp:ListItem>
                            <asp:ListItem Value="5000000">More than 20 Lakhs</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Work Location</label>
                        <asp:DropDownList ID="ddlWorkingLocation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(2)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(4)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 4: Family Background -->
        <div id="step4" class="form-section">
            <h3 class="section-title marathi-font">👨‍👩‍👧‍👦 Family Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Family Type</label>
                        <asp:DropDownList ID="ddlFamilyType" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Joint Family">Joint Family</asp:ListItem>
                            <asp:ListItem Value="Nuclear Family">Nuclear Family</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Family Status</label>
                        <asp:DropDownList ID="ddlFamilyStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Middle Class">Middle Class</asp:ListItem>
                            <asp:ListItem Value="Upper Middle Class">Upper Middle Class</asp:ListItem>
                            <asp:ListItem Value="Rich">Rich</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Father's Occupation</label>
                        <asp:DropDownList ID="ddlFatherOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Farmer">Farmer</asp:ListItem>
                            <asp:ListItem Value="Retired">Retired</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Mother's Occupation</label>
                        <asp:DropDownList ID="ddlMotherOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Housewife">Housewife</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Retired">Retired</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Number of Brothers</label>
                        <asp:DropDownList ID="ddlNoOfBrothers" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">0</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                            <asp:ListItem Value="4">4</asp:ListItem>
                            <asp:ListItem Value="5">More than 5</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Number of Sisters</label>
                        <asp:DropDownList ID="ddlNoOfSisters" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="0">0</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                            <asp:ListItem Value="4">4</asp:ListItem>
                            <asp:ListItem Value="5">More than 5</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label">Native Place</label>
                        <asp:DropDownList ID="ddlNativePlace" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">More about Family</label>
                <asp:TextBox ID="txtFamilyDetails" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="More about family..."></asp:TextBox>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(3)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(5)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 5: Partner Expectations -->
        <div id="step5" class="form-section">
            <h3 class="section-title marathi-font">💑 Partner Expectations</h3>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Age (Minimum)</label>
                        <asp:DropDownList ID="ddlMinAge" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="18">18</asp:ListItem>
                            <asp:ListItem Value="20">20</asp:ListItem>
                            <asp:ListItem Value="22">22</asp:ListItem>
                            <asp:ListItem Value="24">24</asp:ListItem>
                            <asp:ListItem Value="26">26</asp:ListItem>
                            <asp:ListItem Value="28">28</asp:ListItem>
                            <asp:ListItem Value="30">30</asp:ListItem>
                            <asp:ListItem Value="32">32</asp:ListItem>
                            <asp:ListItem Value="34">34</asp:ListItem>
                            <asp:ListItem Value="36">36</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Age (Maximum)</label>
                        <asp:DropDownList ID="ddlMaxAge" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="25">25</asp:ListItem>
                            <asp:ListItem Value="27">27</asp:ListItem>
                            <asp:ListItem Value="29">29</asp:ListItem>
                            <asp:ListItem Value="31">31</asp:ListItem>
                            <asp:ListItem Value="33">33</asp:ListItem>
                            <asp:ListItem Value="35">35</asp:ListItem>
                            <asp:ListItem Value="37">37</asp:ListItem>
                            <asp:ListItem Value="39">39</asp:ListItem>
                            <asp:ListItem Value="41">41</asp:ListItem>
                            <asp:ListItem Value="43">43</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Minimum Height</label>
                        <asp:DropDownList ID="ddlMinHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="4'6&quot;">4'6"</asp:ListItem>
                            <asp:ListItem Value="4'7&quot;">4'7"</asp:ListItem>
                            <asp:ListItem Value="4'8&quot;">4'8"</asp:ListItem>
                            <asp:ListItem Value="4'9&quot;">4'9"</asp:ListItem>
                            <asp:ListItem Value="4'10&quot;">4'10"</asp:ListItem>
                            <asp:ListItem Value="4'11&quot;">4'11"</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Maximum Height</label>
                        <asp:DropDownList ID="ddlMaxHeight" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                            <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                            <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                            <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                            <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                            <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                            <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                            <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                            <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                            <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                            <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                            <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                            <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                            <asp:ListItem Value="6'1&quot;">6'1"</asp:ListItem>
                            <asp:ListItem Value="6'2&quot;">6'2"</asp:ListItem>
                            <asp:ListItem Value="6'3&quot;">6'3"</asp:ListItem>
                            <asp:ListItem Value="6'4&quot;">6'4"</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Religion</label>
                        <asp:DropDownList ID="ddlPreferredReligion" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Islam">Islam</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Caste</label>
                        <asp:DropDownList ID="ddlPreferredCaste" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maratha">Maratha</asp:ListItem>
                            <asp:ListItem Value="Kunbi">Kunbi</asp:ListItem>
                            <asp:ListItem Value="Brahmin">Brahmin</asp:ListItem>
                            <asp:ListItem Value="Dalit">Dalit</asp:ListItem>
                            <asp:ListItem Value="Vani">Vani</asp:ListItem>
                            <asp:ListItem Value="Tamboli">Tamboli</asp:ListItem>
                            <asp:ListItem Value="Sonar">Sonar</asp:ListItem>
                            <asp:ListItem Value="Mali">Mali</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                            <asp:ListItem Value="Agari">Agari</asp:ListItem>
                            <asp:ListItem Value="Chambhar">Chambhar</asp:ListItem>
                            <asp:ListItem Value="Dhangar">Dhangar</asp:ListItem>
                            <asp:ListItem Value="Gavli">Gavli</asp:ListItem>
                            <asp:ListItem Value="Lohar">Lohar</asp:ListItem>
                            <asp:ListItem Value="Sutar">Sutar</asp:ListItem>
                            <asp:ListItem Value="Shimpi">Shimpi</asp:ListItem>
                            <asp:ListItem Value="Nhavi">Nhavi</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Education</label>
                        <asp:DropDownList ID="ddlPreferredEducation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                            <asp:ListItem Value="10th">10th</asp:ListItem>
                            <asp:ListItem Value="12th">12th</asp:ListItem>
                            <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                            <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="MBA">MBA</asp:ListItem>
                            <asp:ListItem Value="CA">CA</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label">Preferred Occupation</label>
                        <asp:DropDownList ID="ddlPreferredOccupation" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Any">Any</asp:ListItem>
                            <asp:ListItem Value="Job">Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                            <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">Partner Expectations (Detailed)</label>
                <asp:TextBox ID="txtPartnerExpectations" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="Write in detail about your ideal partner..."></asp:TextBox>
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(4)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <button type="button" class="btn btn-marathi marathi-font" onclick="nextStep(6)">
                    Next <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 6: Photo Upload & Final -->
        <div id="step6" class="form-section">
            <h3 class="section-title marathi-font">📸 Photos and Final Information</h3>
            
            <!-- Login Information -->
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Confirm Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">Mobile Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" TextMode="Phone" placeholder="Your mobile number"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Location Information -->
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">State</label>
                        <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Maharashtra">Maharashtra</asp:ListItem>
                            <asp:ListItem Value="Karnataka">Karnataka</asp:ListItem>
                            <asp:ListItem Value="Gujarat">Gujarat</asp:ListItem>
                            <asp:ListItem Value="Madhya Pradesh">Madhya Pradesh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">District</label>
                        <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="marathi-font form-label required-field">City</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Pune">Pune</asp:ListItem>
                            <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                            <asp:ListItem Value="Nagpur">Nagpur</asp:ListItem>
                            <asp:ListItem Value="Nashik">Nashik</asp:ListItem>
                            <asp:ListItem Value="Aurangabad">Aurangabad</asp:ListItem>
                            <asp:ListItem Value="Kolhapur">Kolhapur</asp:ListItem>
                            <asp:ListItem Value="Satara">Satara</asp:ListItem>
                            <asp:ListItem Value="Sangli">Sangli</asp:ListItem>
                            <asp:ListItem Value="Solapur">Solapur</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Profile Photo Upload -->
            <div class="photo-upload-area" onclick="document.getElementById('<%= fuProfilePhoto.ClientID %>').click()">
                <div class="feature-icon">
                    <i class="fas fa-camera"></i>
                </div>
                <h5 class="marathi-font">📷 Profile Photo *</h5>
                <p class="text-muted marathi-font">Please upload a clear and recent profile photo</p>
                <asp:FileUpload ID="fuProfilePhoto" runat="server" CssClass="form-control-file d-none" accept="image/*" />
                <div id="profilePreview" class="mt-3"></div>
            </div>

            <!-- Additional Photos Upload -->
            <div class="photo-upload-area" onclick="document.getElementById('<%= fuAdditionalPhotos.ClientID %>').click()">
                <div class="feature-icon">
                    <i class="fas fa-images"></i>
                </div>
                <h5 class="marathi-font">🖼️ Additional Photos (up to 5)</h5>
                <p class="text-muted marathi-font">Upload your additional photos (maximum 5 photos)</p>
                <asp:FileUpload ID="fuAdditionalPhotos" runat="server" CssClass="form-control-file d-none" 
                    accept="image/*" multiple="multiple" />
                <div id="additionalPhotosPreview" class="mt-3 d-flex flex-wrap"></div>
            </div>

            <!-- About Me -->
            <div class="form-group">
                <label class="marathi-font form-label">About Me</label>
                <asp:TextBox ID="txtAboutMe" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" 
                    placeholder="Write briefly about yourself..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="marathi-font form-label">Hobbies, Interests</label>
                <asp:TextBox ID="txtHobbies" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" 
                    placeholder="Write about your hobbies and interests..."></asp:TextBox>
            </div>

            <div class="alert alert-info marathi-font" style="border-radius: 12px; border-left: 4px solid #667eea;">
                <strong>📝 Note:</strong> Ensure all information is accurate and true. Upload only clear and recent photos.
            </div>

            <div class="text-right mt-4">
                <button type="button" class="btn btn-secondary marathi-font" onclick="prevStep(5)">
                    <i class="fas fa-arrow-left mr-2"></i> Back
                </button>
                <asp:Button ID="btnSubmit" runat="server" Text="Complete Registration 🎉" CssClass="btn btn-marathi marathi-font" 
                    OnClick="btnSubmit_Click" />
            </div>
        </div>

        <!-- Celebration Animation -->
        <div id="celebration" class="celebration">
            <div class="text-center">
                <div class="feature-icon" style="margin: 0 auto 20px; background: rgba(255,255,255,0.2);">
                    <i class="fas fa-heart" style="font-size: 24px;"></i>
                </div>
                <h1 class="marathi-font" style="font-size: 3rem; margin-bottom: 20px;">🎉 Congratulations! 🎉</h1>
                <h3 class="marathi-font" style="margin-bottom: 20px;">Your Marathi Matrimony registration has been completed successfully!</h3>
                <p class="marathi-font">A confirmation message has been sent to your email.</p>
                <p class="marathi-font">You can now start searching for your ideal partner.</p>
                <div class="mt-4">
                    <a href="Login.aspx" class="btn btn-marathi marathi-font">Login</a>
                    <a href="BrowseProfiles.aspx" class="btn btn-outline-light marathi-font ml-2">Browse Profiles</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentStep = 1;
        let additionalPhotos = [];

        function nextStep(step) {
            if (validateStep(currentStep)) {
                document.getElementById('step' + currentStep).classList.remove('active');
                document.getElementById('step' + step).classList.add('active');
                updateProgressBar(currentStep, step);
                currentStep = step;
            }
        }

        function prevStep(step) {
            document.getElementById('step' + currentStep).classList.remove('active');
            document.getElementById('step' + step).classList.add('active');
            updateProgressBar(currentStep, step);
            currentStep = step;
        }

        function updateProgressBar(fromStep, toStep) {
            const steps = document.querySelectorAll('.progress-step');
            steps.forEach(step => {
                const stepNum = parseInt(step.getAttribute('data-step'));
                step.classList.remove('step-active', 'step-completed');

                if (stepNum === toStep) {
                    step.classList.add('step-active');
                } else if (stepNum < toStep) {
                    step.classList.add('step-completed');
                }
            });
        }

        function validateStep(step) {
            // Add validation logic for each step
            // Return true if valid, false otherwise
            return true;
        }

        function toggleHinduFields() {
            var religion = document.getElementById('<%= ddlReligion.ClientID %>');
            var gothraSection = document.getElementById('gothraSection');
            
            if (religion.value === 'Hindu') {
                gothraSection.style.display = 'block';
            } else {
                gothraSection.style.display = 'block';
            }
        }

        function showCelebration() {
            document.querySelectorAll('.form-section').forEach(section => {
                section.style.display = 'none';
            });
            document.getElementById('celebration').style.display = 'block';
            createConfetti();
        }

        function createConfetti() {
            const colors = ['#ff6b6b', '#51cf66', '#339af0', '#fcc419', '#cc5de8', '#20c997'];
            for (let i = 0; i < 150; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDelay = Math.random() * 2 + 's';
                confetti.style.width = Math.random() * 10 + 8 + 'px';
                confetti.style.height = Math.random() * 10 + 8 + 'px';
                document.body.appendChild(confetti);

                setTimeout(() => {
                    confetti.remove();
                }, 3000);
            }
        }

        // Profile photo preview functionality
        document.getElementById('<%= fuProfilePhoto.ClientID %>').addEventListener('change', function (e) {
            previewImage(e.target.files[0], 'profilePreview');
        });

        // Additional photos preview functionality
        document.getElementById('<%= fuAdditionalPhotos.ClientID %>').addEventListener('change', function (e) {
            previewMultipleImages(e.target.files, 'additionalPhotosPreview');
        });

        function previewImage(file, previewId) {
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'preview-image';
                    document.getElementById(previewId).innerHTML = '';
                    document.getElementById(previewId).appendChild(img);
                }
                reader.readAsDataURL(file);
            }
        }

        function previewMultipleImages(files, previewId) {
            const previewContainer = document.getElementById(previewId);

            if (files) {
                const fileArray = Array.from(files);

                // Limit to 5 files
                if (fileArray.length > 5) {
                    alert('You can only upload 5 photos');
                    return;
                }

                fileArray.forEach((file, index) => {
                    if (index >= 5) return;

                    if (file.type.match('image.*')) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            const imgContainer = document.createElement('div');
                            imgContainer.className = 'photo-preview-container';

                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'preview-image';
                            img.style.width = '100px';
                            img.style.height = '100px';

                            const removeBtn = document.createElement('button');
                            removeBtn.type = 'button';
                            removeBtn.className = 'remove-photo-btn';
                            removeBtn.innerHTML = '×';
                            removeBtn.onclick = function () {
                                imgContainer.remove();
                                updateFileInput(file);
                            };

                            imgContainer.appendChild(img);
                            imgContainer.appendChild(removeBtn);
                            previewContainer.appendChild(imgContainer);
                        }
                        reader.readAsDataURL(file);
                    }
                });
            }
        }

        function updateFileInput(fileToRemove) {
            // This is a simplified version - in production you might want to implement
            // a more complex solution to manage the file input
            console.log('File removal would require more complex implementation');
        }

        // View Profile - Redirect to ViewProfile page
        function viewProfile(userID) {
            console.log('Navigating to profile:', userID);
            window.location.href = 'ViewProfile.aspx?UserID=' + userID;
        }

        // Initialize on page load
        window.onload = function () {
            toggleHinduFields();
        };
    </script>
</asp:Content>








--%>
