<%@ Page Title="Marathi Matrimony - Browse Profiles" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="BrowseProfile.aspx.cs" Inherits="JivanBandhan4.BrowseProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .browse-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .page-header {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 25px;
            margin-top: 20px;
        }
        
        .filters-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .results-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .filter-group {
            margin-bottom: 25px;
        }
        
        .filter-label {
            color: white;
            font-weight: 600;
            margin-bottom: 10px;
            display: block;
            font-size: 0.95rem;
        }
        
        .filter-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 12px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            background: rgba(255,255,255,0.15);
            border-color: rgba(255,255,255,0.5);
            outline: none;
            box-shadow: 0 0 0 3px rgba(255,255,255,0.1);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 600;
            width: 100%;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 600;
            width: 100%;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header {
            position: relative;
            height: 160px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container {
            position: absolute;
            bottom: -60px;
            left: 50%;
            transform: translateX(-50%);
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 4;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content {
            padding: 70px 20px 20px;
            text-align: center;
            background: transparent;
            position: relative;
            z-index: 2;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 15px;
            text-align: left;
        }
        
        .detail-item {
            color: rgba(255,255,255,0.8);
            font-size: 0.8rem;
        }
        
        .detail-label {
            font-weight: 600;
            color: rgba(255,255,255,0.9);
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 8px 12px;
            border: none;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 90px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }

        .membership-tag {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 0.7rem;
            font-weight: bold;
            margin-left: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
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

        .contact-section {
            margin: 10px 0;
        }

        .contact-number {
            background: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            padding: 6px 10px;
            border-radius: 8px;
            font-weight: bold;
            margin: 8px 0;
            border: 1px solid rgba(40, 167, 69, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
            font-size: 0.8rem;
        }

        .contact-locked {
            background: rgba(108, 117, 125, 0.2);
            color: rgba(255,255,255,0.6);
            padding: 6px 10px;
            border-radius: 8px;
            font-weight: bold;
            margin: 8px 0;
            border: 1px solid rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
            font-size: 0.8rem;
        }

        .view-contact-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            color: white !important;
            border: none !important;
            border-radius: 12px !important;
            padding: 6px 12px !important;
            font-size: 0.75rem !important;
            font-weight: 600 !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            margin-top: 5px !important;
            display: block !important;
            width: 100% !important;
        }

        .view-contact-btn:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4) !important;
            background: linear-gradient(135deg, #218838 0%, #1e9e6f 100%) !important;
        }

        .results-info {
            color: rgba(255,255,255,0.8);
            margin-bottom: 20px;
            padding: 15px;
            background: rgba(255,255,255,0.1);
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                padding: 20px;
            }
            
            .results-content {
                padding: 20px;
            }
            
            .filters-sidebar {
                padding: 20px;
            }
        }
    </style>

    <div class="browse-container">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">
                            <i class="fas fa-search"></i> Browse Profiles
                        </h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">
                            Find your perfect match with advanced search filters
                        </p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Label ID="lblSearchInfo" runat="server" CssClass="marathi-font" 
                            style="color: rgba(255,255,255,0.9); background: rgba(255,255,255,0.1); padding: 10px 15px; border-radius: 12px; display: inline-block;">
                            Searching for: <asp:Label ID="lblGenderSearch" runat="server" Font-Bold="true"></asp:Label> profiles
                        </asp:Label>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Filters Sidebar -->
                <div class="filters-sidebar">
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-filter"></i> Search Filters
                    </h3>
                    
                    <div class="filter-group">
                        <label class="filter-label marathi-font">Age Range</label>
                        <div class="row">
                            <div class="col-6">
                                <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                    placeholder="Min" TextMode="Number" min="18" max="80"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                    placeholder="Max" TextMode="Number" min="18" max="80"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">Religion (धर्म)</label>
                        <asp:DropDownList ID="ddlReligion" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Religions</asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                            <asp:ListItem Value="Jain">Jain</asp:ListItem>
                            <asp:ListItem Value="Sikh">Sikh</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">Annual Income</label>
                        <asp:DropDownList ID="ddlIncome" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">Any Income</asp:ListItem>
                            <asp:ListItem Value="0-200000">Below 2 Lakhs</asp:ListItem>
                            <asp:ListItem Value="200000-500000">2 - 5 Lakhs</asp:ListItem>
                            <asp:ListItem Value="500000-1000000">5 - 10 Lakhs</asp:ListItem>
                            <asp:ListItem Value="1000000-2000000">10 - 20 Lakhs</asp:ListItem>
                            <asp:ListItem Value="2000000-5000000">20 - 50 Lakhs</asp:ListItem>
                            <asp:ListItem Value="5000000+">Above 50 Lakhs</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">Marital Status</label>
                        <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">Any Status</asp:ListItem>
                            <asp:ListItem Value="Never Married">Never Married</asp:ListItem>
                            <asp:ListItem Value="Divorced">Divorced</asp:ListItem>
                            <asp:ListItem Value="Widowed">Widowed</asp:ListItem>
                            <asp:ListItem Value="Awaiting Divorce">Awaiting Divorce</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">Education</label>
                        <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Education</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">Occupation</label>
                        <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Occupations</asp:ListItem>
                            <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                            <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Not Working">Not Working</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label marathi-font">City</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Cities</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <asp:Button ID="btnSearch" runat="server" Text="🔍 Search Profiles" 
                            CssClass="btn btn-primary marathi-font" OnClick="btnSearch_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="🔄 Reset Filters" 
                            CssClass="btn btn-secondary marathi-font mt-2" OnClick="btnReset_Click" />
                    </div>
                </div>
                
                <!-- Results Content -->
                <div class="results-content">
                    <div class="results-info marathi-font">
                        <i class="fas fa-info-circle"></i> 
                        <asp:Label ID="lblResultsCount" runat="server" Text=""></asp:Label>
                    </div>

                    <div class="profile-grid">
                        <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                            <ItemTemplate>
                                <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                    <div class="profile-header" id="profileHeaderBackground" runat="server">
                                        <div class="profile-photo-container">
                                            <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo" 
                                                ImageUrl='<%# GetProfilePhotoUrl(Container.DataItem) %>' 
                                                onerror="this.src='Images/default-profile.jpg'" />
                                        </div>
                                        <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                        <div class="premium-badge" id="premiumBadge" runat="server" 
                                            style='display: <%# (Eval("IsPremium") != DBNull.Value && Convert.ToBoolean(Eval("IsPremium"))) ? "block" : "none" %>'>
                                            ⭐ Premium
                                        </div>
                                    </div>
                                    <div class="profile-content">
                                        <div class="profile-name marathi-font">
                                            <%# Eval("FullName") %>
                                        </div>
                                        <div class="profile-age marathi-font">
                                            <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                        </div>
                                        <div class="profile-location marathi-font">
                                            <i class="fas fa-map-marker-alt"></i> 
                                            <%# Eval("City") %>, <%# Eval("State") %>
                                        </div>
                                        
                                        <div class="profile-details">
                                            <div class="detail-item">
                                                <span class="detail-label">Education:</span> <%# Eval("Education") %>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Religion:</span> <%# Eval("Religion") %>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Height:</span> 
                                                <asp:Literal ID="ltHeight" runat="server" Text='<%# FormatHeight(Eval("Height")) %>'></asp:Literal>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Caste:</span> 
                                                <asp:Literal ID="ltCaste" runat="server" Text='<%# FormatCaste(Eval("Caste"), Eval("SubCaste")) %>'></asp:Literal>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Income:</span> 
                                                <asp:Literal ID="ltIncome" runat="server" Text='<%# FormatIncome(Eval("AnnualIncome")) %>'></asp:Literal>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Marital Status:</span> <%# Eval("MaritalStatus") %>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Mother Tongue:</span> 
                                                <asp:Literal ID="ltMotherTongue" runat="server" Text='<%# FormatMotherTongue(Eval("MotherTongue")) %>'></asp:Literal>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Company:</span> 
                                                <asp:Literal ID="ltCompany" runat="server" Text='<%# FormatCompany(Eval("Company"), Eval("WorkingLocation")) %>'></asp:Literal>
                                            </div>
                                        </div>
                                        
                                        <!-- Contact Number Section -->
                                        <div class="contact-section">
                                            <div class="contact-number" id="contactNumberDisplay" runat="server" style="display: none;">
                                                <i class="fas fa-phone"></i> 
                                                <asp:Literal ID="ltContactNumber" runat="server"></asp:Literal>
                                            </div>
                                            <div class="contact-locked" id="contactLocked" runat="server" style="display: none;">
                                                <i class="fas fa-lock"></i> 
                                                Upgrade to view contact number
                                            </div>
                                            <button class="view-contact-btn marathi-font" onclick='viewContactNumber(event, <%# Eval("UserID") %>, "<%# Eval("Phone") %>")'>
                                                <i class="fas fa-eye"></i> View Contact
                                            </button>
                                        </div>
                                        
                                        <div class="profile-actions">
                                            <button class="btn-action btn-interest marathi-font" 
                                                onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                💝 Interest
                                            </button>
                                            <button class="btn-action btn-message marathi-font"
                                                onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                💌 Message
                                            </button>
                                            <button class="btn-action btn-shortlist marathi-font" 
                                                onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                ⭐ Shortlist
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    
                    <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-users fa-3x mb-3"></i>
                        <h4 class="marathi-font">No profiles found</h4>
                        <p class="marathi-font">Try adjusting your search criteria or check back later for new profiles</p>
                        <asp:Button ID="btnResetNoResults" runat="server" Text="🔄 Reset Filters" 
                            CssClass="btn btn-primary marathi-font mt-3" OnClick="btnReset_Click" />
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserMembership" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // View Contact Number with Membership Check
        function viewContactNumber(event, profileUserID, phoneNumber) {
            event.stopPropagation();
            event.preventDefault();

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            const currentUserMembership = document.getElementById('<%= hdnCurrentUserMembership.ClientID %>').value;

            // Check if user has Silver, Gold, or Platinum membership
            const canViewContact = currentUserMembership === 'Silver' || 
                                  currentUserMembership === 'Gold' || 
                                  currentUserMembership === 'Platinum';

            if (canViewContact) {
                // Show contact number
                const contactSection = event.target.closest('.contact-section');
                const contactDisplay = contactSection.querySelector('.contact-number');
                const contactLocked = contactSection.querySelector('.contact-locked');
                const viewButton = contactSection.querySelector('.view-contact-btn');
                
                if (contactDisplay && phoneNumber && phoneNumber !== '') {
                    contactDisplay.style.display = 'block';
                    if (contactLocked) contactLocked.style.display = 'none';
                    if (viewButton) viewButton.style.display = 'none';
                    
                    // Log contact view
                    logContactView(currentUserID, profileUserID);
                } else {
                    // Contact number not available
                    if (contactLocked) {
                        contactLocked.style.display = 'block';
                        contactLocked.innerHTML = '<i class="fas fa-info-circle"></i> Contact number not available';
                    }
                    if (viewButton) viewButton.style.display = 'none';
                }
            } else {
                // Redirect to membership page
                if (confirm('You need a Silver, Gold, or Platinum membership to view contact numbers. Would you like to upgrade?')) {
                    window.location.href = 'Membership.aspx';
                }
            }
        }

        // Log contact view
        function logContactView(viewerUserID, profileUserID) {
            $.ajax({
                type: "POST",
                url: "BrowseProfile.aspx/LogContactView",
                data: JSON.stringify({
                    viewerUserID: parseInt(viewerUserID),
                    profileUserID: parseInt(profileUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Contact view logged successfully');
                },
                error: function () {
                    console.log('Error logging contact view');
                }
            });
        }

        // Send Interest with Block Check and Membership Limit Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "BrowseProfile.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check and Membership Limit Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "BrowseProfile.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "BrowseProfile.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "BrowseProfile.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            console.log('Browse Profiles page loaded successfully');
        });
    </script>
</asp:Content>