

<%@ Page Title="Marathi Matrimony - Profile Views" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="TotalViews.aspx.cs" Inherits="JivanBandhan4.TotalViews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .profile-views-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
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
            padding: 25px;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .back-button {
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 10px 20px;
            border-radius: 15px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        
        .back-button:hover {
            background: rgba(255,255,255,0.2);
            transform: translateX(-5px);
            color: white;
            text-decoration: none;
        }
        
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: white;
            display: block;
        }
        
        .stat-label {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }

        /* Dashboard-style Profile Cards */
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
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
        
        .profile-content-large {
            padding: 95px 20px 20px;
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
        
        .profile-education {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-religion {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
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

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .contact-section {
            margin: 15px 0;
        }

        .contact-number {
            background: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(40, 167, 69, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        .contact-locked {
            background: rgba(108, 117, 125, 0.2);
            color: rgba(255,255,255,0.6);
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        .view-contact-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            color: white !important;
            border: none !important;
            border-radius: 15px !important;
            padding: 8px 15px !important;
            font-size: 0.8rem !important;
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

        .membership-tag {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.75rem;
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

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
            margin-top: 20px;
        }

        .view-time {
            background: rgba(255,255,255,0.1);
            padding: 8px 12px;
            border-radius: 15px;
            color: rgba(255,255,255,0.9);
            font-size: 0.8rem;
            display: inline-block;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        /* Table View for Larger Screens */
        .profile-views-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .profile-views-table th {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .profile-views-table td {
            padding: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.9);
            vertical-align: middle;
        }

        .profile-views-table tr:hover {
            background: rgba(255, 255, 255, 0.08);
        }

        .table-user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .table-user-photo {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
        }

        .table-user-details {
            flex: 1;
        }

        .table-user-name {
            font-weight: bold;
            color: white;
            margin-bottom: 4px;
        }

        .table-user-basic {
            font-size: 0.85rem;
            color: rgba(255,255,255,0.8);
            margin-bottom: 2px;
        }

        .table-user-location {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.7);
        }

        .table-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }

        .btn-table-action {
            padding: 6px 12px;
            border: none;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        /* View Toggle */
        .view-toggle {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            gap: 10px;
        }

        .view-toggle-btn {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: rgba(255,255,255,0.8);
            padding: 8px 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .view-toggle-btn.active {
            background: rgba(255,255,255,0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }

        .view-toggle-btn:hover {
            background: rgba(255,255,255,0.15);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
            
            .stats-overview {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 10px;
            }
            
            .stat-number {
                font-size: 1.5rem;
            }

            .profile-views-table {
                display: none;
            }

            .mobile-view {
                display: block;
            }
        }

        @media (min-width: 769px) {
            .mobile-view {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-actions {
                flex-direction: column;
                gap: 5px;
            }
            
            .btn-action {
                max-width: 100%;
            }
            
            .block-report-actions {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>

    <div class="profile-views-container">
        <div class="container">
            <!-- Back Button -->
            <a href="Dashboard.aspx" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            
            <!-- Page Header -->
            <div class="page-header glass-effect">
                <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">
                    <i class="fas fa-eye"></i> Your Profile Views
                </h1>
                <p class="marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 0;">
                    See who viewed your profile
                </p>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="totalViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Total Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="todayViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Today's Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="weekViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Last 7 Days Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="monthViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Last 30 Days Views</span>
                </div>
            </div>

            <!-- View Toggle -->
            <div class="view-toggle">
                <button class="view-toggle-btn active" onclick="toggleView('card')">
                    <i class="fas fa-th-large"></i> Card View
                </button>
                <button class="view-toggle-btn" onclick="toggleView('table')">
                    <i class="fas fa-table"></i> Table View
                </button>
            </div>

            <!-- Profile Views Content -->
            <div class="glass-effect" style="padding: 25px;">
                <!-- Table View (Desktop) -->
                <div id="tableView" class="desktop-view">
                    <table class="profile-views-table">
                        <thead>
                            <tr>
                                <th>User Profile</th>
                                <th>Basic Information</th>
                                <th>Viewed On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptProfileViewsTable" runat="server" OnItemDataBound="rptProfileViewsTable_ItemDataBound">
                                <ItemTemplate>
                                    <tr onclick='viewProfile(<%# Eval("ViewerUserID") %>)'>
                                        <td>
                                            <div class="table-user-info">
                                                <asp:Image ID="imgViewerTable" runat="server" CssClass="table-user-photo" 
                                                    ImageUrl='<%# GetProfilePhotoUrl(Convert.ToInt32(Eval("ViewerUserID"))) %>'
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                                <div class="table-user-details">
                                                    <div class="table-user-name marathi-font">
                                                        <%# Eval("ViewerName") %>
                                                        <span class='<%# "membership-tag " + GetMembershipTagClass(Eval("ViewerMembershipType")) %>'>
                                                            <%# Eval("ViewerMembershipType") %>
                                                        </span>
                                                    </div>
                                                    <div class="table-user-basic marathi-font">
                                                        <asp:Literal ID="ltViewerAgeTable" runat="server" Text='<%# CalculateAgeInline(Eval("ViewerDOB")) %>'></asp:Literal> Years • <%# Eval("ViewerOccupation") %>
                                                    </div>
                                                    <div class="table-user-location marathi-font">
                                                        <i class="fas fa-map-marker-alt"></i> 
                                                        <%# Eval("ViewerCity") %>, <%# Eval("ViewerState") %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="marathi-font" style="font-size: 0.85rem;">
                                                <div><%# Eval("ViewerEducation") %></div>
                                                <div><%# Eval("ViewerReligion") %></div>
                                                <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>" style="display: inline-block; margin-top: 5px;"></div>
                                                <span style="font-size: 0.75rem; color: rgba(255,255,255,0.7);">
                                                    <%# (new Random().Next(0,100) > 50 ? "Online" : "Offline") %>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="view-time marathi-font">
                                                <i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("ViewDate"))) %>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <button class="btn-table-action btn-interest" 
                                                    onclick='sendInterest(event, <%# Eval("ViewerUserID") %>)'>
                                                    💝
                                                </button>
                                                <button class="btn-table-action btn-message"
                                                    onclick='sendMessage(event, <%# Eval("ViewerUserID") %>)'>
                                                    💌
                                                </button>
                                                <button class="btn-table-action btn-shortlist" 
                                                    onclick='shortlistProfile(event, <%# Eval("ViewerUserID") %>)'>
                                                    ⭐
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                    
                    <asp:Panel ID="pnlNoViewsTable" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-eye-slash fa-3x mb-3"></i>
                        <h4 class="marathi-font">No one has viewed your profile yet</h4>
                        <p class="marathi-font">More people can view your profile if you use it actively</p>
                    </asp:Panel>
                </div>

                <!-- Card View (Mobile) -->
                <div id="cardView" class="mobile-view">
                    <div class="profile-grid">
                        <asp:Repeater ID="rptProfileViews" runat="server" OnItemDataBound="rptProfileViews_ItemDataBound">
                            <ItemTemplate>
                                <div class="profile-card" onclick='viewProfile(<%# Eval("ViewerUserID") %>)'>
                                    <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                        <div class="profile-photo-container-large">
                                            <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                ImageUrl='<%# GetProfilePhotoUrl(Convert.ToInt32(Eval("ViewerUserID"))) %>' 
                                                onerror="this.src='Images/default-profile.jpg'" />
                                        </div>
                                        <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                        <div class="premium-badge" id="premiumBadge" runat="server" 
                                            style='display: <%# Convert.ToBoolean(Eval("IsViewerPremium")) ? "block" : "none" %>'>
                                            ⭐ Premium
                                        </div>
                                    </div>
                                    <div class="profile-content-large">
                                        <div class="view-time">
                                            <i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("ViewDate"))) %>
                                        </div>

                                        <div class="profile-name marathi-font">
                                            <%# Eval("ViewerName") %>
                                            <span class='<%# "membership-tag " + GetMembershipTagClass(Eval("ViewerMembershipType")) %>'>
                                                <%# Eval("ViewerMembershipType") %>
                                            </span>
                                        </div>
                                        <div class="profile-age marathi-font">
                                            <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("ViewerDOB")) %>'></asp:Literal> Years | <%# Eval("ViewerOccupation") %>
                                        </div>
                                        <div class="profile-location marathi-font">
                                            <i class="fas fa-map-marker-alt"></i> 
                                            <%# Eval("ViewerCity") %>, <%# Eval("ViewerState") %>
                                        </div>
                                        <div class="profile-education marathi-font">
                                            <i class="fas fa-graduation-cap"></i> 
                                            <%# Eval("ViewerEducation") %>
                                        </div>
                                        <div class="profile-religion marathi-font">
                                            <i class="fas fa-pray"></i> 
                                            <%# Eval("ViewerReligion") %>
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
                                            <button class="view-contact-btn marathi-font" onclick='viewContactNumber(event, <%# Eval("ViewerUserID") %>, "<%# Eval("ViewerPhone") %>")'>
                                                <i class="fas fa-eye"></i> View Contact
                                            </button>
                                        </div>
                                        
                                        <div class="profile-actions">
                                            <button class="btn-action btn-interest marathi-font" 
                                                onclick='sendInterest(event, <%# Eval("ViewerUserID") %>)'>
                                                💝 Interest
                                            </button>
                                            <button class="btn-action btn-message marathi-font"
                                                onclick='sendMessage(event, <%# Eval("ViewerUserID") %>)'>
                                                💌 Message
                                            </button>
                                            <button class="btn-action btn-shortlist marathi-font" 
                                                onclick='shortlistProfile(event, <%# Eval("ViewerUserID") %>)'>
                                                ⭐ Shortlist
                                            </button>
                                        </div>
                                        
                                        <!-- Block & Report Buttons -->
                                        <div class="block-report-actions">
                                            <button class="btn-block-report btn-block marathi-font" 
                                                onclick='blockUser(event, <%# Eval("ViewerUserID") %>)'>
                                                🚫 Block
                                            </button>
                                            <button class="btn-block-report btn-report marathi-font" 
                                                onclick='reportUser(event, <%# Eval("ViewerUserID") %>)'>
                                                ⚠ Report
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    
                    <asp:Panel ID="pnlNoViews" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-eye-slash fa-3x mb-3"></i>
                        <h4 class="marathi-font">No one has viewed your profile yet</h4>
                        <p class="marathi-font">More people can view your profile if you use it actively</p>
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
        // View Toggle Function
        function toggleView(viewType) {
            const cardView = document.getElementById('cardView');
            const tableView = document.getElementById('tableView');
            const buttons = document.querySelectorAll('.view-toggle-btn');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            
            if (viewType === 'card') {
                cardView.style.display = 'block';
                tableView.style.display = 'none';
                document.querySelector('.view-toggle-btn:nth-child(1)').classList.add('active');
            } else {
                cardView.style.display = 'none';
                tableView.style.display = 'block';
                document.querySelector('.view-toggle-btn:nth-child(2)').classList.add('active');
            }
        }

        // Initialize with card view
        document.addEventListener('DOMContentLoaded', function() {
            toggleView('card');
        });

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
                url: "TotalViews.aspx/LogContactView",
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

        // Send Interest with Block Check
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
                        url: "TotalViews.aspx/SendInterest",
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

        // Send Message with Block Check
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
                        url: "TotalViews.aspx/SendMessage",
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
                url: "TotalViews.aspx/CheckIfBlocked",
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
                url: "TotalViews.aspx/ShortlistProfile",
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

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "TotalViews.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "TotalViews.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

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
    </script>
</asp:Content>






















<%--<%@ Page Title="Marathi Matrimony - Profile Views" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="TotalViews.aspx.cs" Inherits="JivanBandhan4.TotalViews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .profile-views-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
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
            padding: 25px;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .back-button {
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 10px 20px;
            border-radius: 15px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        
        .back-button:hover {
            background: rgba(255,255,255,0.2);
            transform: translateX(-5px);
            color: white;
            text-decoration: none;
        }
        
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: white;
            display: block;
        }
        
        .stat-label {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }

        /* Dashboard-style Profile Cards */
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
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
        
        .profile-content-large {
            padding: 95px 20px 20px;
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
        
        .profile-education {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-religion {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
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

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .contact-section {
            margin: 15px 0;
        }

        .contact-number {
            background: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(40, 167, 69, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        .contact-locked {
            background: rgba(108, 117, 125, 0.2);
            color: rgba(255,255,255,0.6);
            padding: 8px 12px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 0;
            border: 1px solid rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(5px);
            text-align: center;
        }

        .view-contact-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%) !important;
            color: white !important;
            border: none !important;
            border-radius: 15px !important;
            padding: 8px 15px !important;
            font-size: 0.8rem !important;
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

        .membership-tag {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.75rem;
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

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
            margin-top: 20px;
        }

        .view-time {
            background: rgba(255,255,255,0.1);
            padding: 8px 12px;
            border-radius: 15px;
            color: rgba(255,255,255,0.9);
            font-size: 0.8rem;
            display: inline-block;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
            
            .stats-overview {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 10px;
            }
            
            .stat-number {
                font-size: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-actions {
                flex-direction: column;
                gap: 5px;
            }
            
            .btn-action {
                max-width: 100%;
            }
            
            .block-report-actions {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>

    <div class="profile-views-container">
        <div class="container">
            <!-- Back Button -->
            <a href="Dashboard.aspx" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            
            <!-- Page Header -->
            <div class="page-header glass-effect">
                <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">
                    <i class="fas fa-eye"></i> Your Profile Views
                </h1>
                <p class="marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 0;">
                    See who viewed your profile
                </p>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="totalViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Total Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="todayViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Today's Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="weekViewsCount" runat="server">0</span>
                    <span class="stat-label marathi-font">Last 7 Days Views</span>
                </div>
            </div>

            <!-- Profile Views Grid -->
            <div class="glass-effect" style="padding: 25px;">
                <h3 class="marathi-font" style="color: white; margin-bottom: 20px; border-bottom: 2px solid rgba(255,255,255,0.3); padding-bottom: 10px;">
                    <i class="fas fa-users"></i> Users Who Viewed Your Profile
                </h3>
                
                <div class="profile-grid">
                    <asp:Repeater ID="rptProfileViews" runat="server" OnItemDataBound="rptProfileViews_ItemDataBound">
                        <ItemTemplate>
                            <div class="profile-card" onclick='viewProfile(<%# Eval("ViewerUserID") %>)'>
                                <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                    <div class="profile-photo-container-large">
                                        <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                            ImageUrl='<%# GetProfilePhotoUrl(Convert.ToInt32(Eval("ViewerUserID"))) %>' 
                                            onerror="this.src='Images/default-profile.jpg'" />
                                    </div>
                                    <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                    <div class="premium-badge" id="premiumBadge" runat="server" 
                                        style='display: <%# Convert.ToBoolean(Eval("IsViewerPremium")) ? "block" : "none" %>'>
                                        ⭐ Premium
                                    </div>
                                </div>
                                <div class="profile-content-large">
                                    <div class="view-time">
                                        <i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("ViewDate"))) %>
                                    </div>

                                    <div class="profile-name marathi-font">
                                        <%# Eval("ViewerName") %>
                                        <span class='<%# "membership-tag " + GetMembershipTagClass(Eval("ViewerMembershipType")) %>'>
                                            <%# Eval("ViewerMembershipType") %>
                                        </span>
                                    </div>
                                    <div class="profile-age marathi-font">
                                        <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("ViewerDOB")) %>'></asp:Literal> Years | <%# Eval("ViewerOccupation") %>
                                    </div>
                                    <div class="profile-location marathi-font">
                                        <i class="fas fa-map-marker-alt"></i> 
                                        <%# Eval("ViewerCity") %>, <%# Eval("ViewerState") %>
                                    </div>
                                    <div class="profile-education marathi-font">
                                        <i class="fas fa-graduation-cap"></i> 
                                        <%# Eval("ViewerEducation") %>
                                    </div>
                                    <div class="profile-religion marathi-font">
                                        <i class="fas fa-pray"></i> 
                                        <%# Eval("ViewerReligion") %>
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
                                        <button class="view-contact-btn marathi-font" onclick='viewContactNumber(event, <%# Eval("ViewerUserID") %>, "<%# Eval("ViewerPhone") %>")'>
                                            <i class="fas fa-eye"></i> View Contact
                                        </button>
                                    </div>
                                    
                                    <div class="profile-actions">
                                        <button class="btn-action btn-interest marathi-font" 
                                            onclick='sendInterest(event, <%# Eval("ViewerUserID") %>)'>
                                            💝 Interest
                                        </button>
                                        <button class="btn-action btn-message marathi-font"
                                            onclick='sendMessage(event, <%# Eval("ViewerUserID") %>)'>
                                            💌 Message
                                        </button>
                                        <button class="btn-action btn-shortlist marathi-font" 
                                            onclick='shortlistProfile(event, <%# Eval("ViewerUserID") %>)'>
                                            ⭐ Shortlist
                                        </button>
                                    </div>
                                    
                                    <!-- Block & Report Buttons -->
                                    <div class="block-report-actions">
                                        <button class="btn-block-report btn-block marathi-font" 
                                            onclick='blockUser(event, <%# Eval("ViewerUserID") %>)'>
                                            🚫 Block
                                        </button>
                                        <button class="btn-block-report btn-report marathi-font" 
                                            onclick='reportUser(event, <%# Eval("ViewerUserID") %>)'>
                                            ⚠ Report
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <asp:Panel ID="pnlNoViews" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-eye-slash fa-3x mb-3"></i>
                    <h4 class="marathi-font">No one has viewed your profile yet</h4>
                    <p class="marathi-font">More people can view your profile if you use it actively</p>
                </asp:Panel>
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
                url: "TotalViews.aspx/LogContactView",
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

        // Send Interest with Block Check
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
                        url: "TotalViews.aspx/SendInterest",
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

        // Send Message with Block Check
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
                        url: "TotalViews.aspx/SendMessage",
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
                url: "TotalViews.aspx/CheckIfBlocked",
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
                url: "TotalViews.aspx/ShortlistProfile",
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

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "TotalViews.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "TotalViews.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

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
            console.log('Total Views page loaded with dashboard-style profiles');
        });
    </script>
</asp:Content>--%>
