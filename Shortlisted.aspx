





<%@ Page Title="Shortlisted Profiles - JivanBandhan" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Shortlisted.aspx.cs" Inherits="JivanBandhan4.Shortlisted" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .shortlist-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #d63384 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            /* Remove overflow-x: hidden to prevent extra scroll bar */
        }
        
        .shortlist-container::before {
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
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.15);
            position: relative;
            border: 1px solid rgba(255,255,255,0.3);
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
        
        .shortlist-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        
        .shortlist-content::before {
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
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 2.2rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 100px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        .shortlist-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .stat-number {
            display: block;
            font-size: 2.5rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 1rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .shortlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 25px;
        }
        
        .shortlist-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
        }
        
        .shortlist-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .shortlist-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 60px rgba(0,0,0,0.2);
        }
        
        .shortlist-card:hover::before {
            opacity: 0.3;
        }
        
        .shortlist-header {
            position: relative;
            height: 200px; /* Increased height for larger photo */
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .shortlist-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.8;
            transition: transform 0.4s ease;
        }
        
        .shortlist-card:hover .shortlist-bg {
            transform: scale(1.1);
        }
        
        .shortlist-photo-container {
            position: absolute;
            bottom: -80px; /* Adjusted for larger photo */
            left: 50%;
            transform: translateX(-50%);
            width: 160px; /* Doubled from 80px to 160px */
            height: 160px; /* Doubled from 80px to 160px */
            border-radius: 50%;
            border: 6px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }
        
        .shortlist-photo-container:hover {
            transform: translateX(-50%) scale(1.15);
            border-color: #d63384;
            box-shadow: 0 20px 50px rgba(214, 51, 132, 0.4);
        }
        
        .shortlist-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        .shortlist-card:hover .shortlist-photo {
            transform: scale(1.1);
        }
        
        .online-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .shortlist-content-area {
            padding: 100px 25px 25px; /* Increased padding to accommodate larger photo */
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .shortlist-name {
            font-size: 1.4rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .shortlist-age {
            color: #d63384;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .shortlist-location {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .shortlist-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin-bottom: 20px;
        }
        
        .tag {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            color: #495057;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        
        .tag:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .shortlist-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            max-width: 120px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-action:hover::before {
            left: 100%;
        }
        
        .btn-view {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-remove {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 30px;
            color: #6c757d;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 25px;
            border: 2px dashed rgba(108, 117, 125, 0.3);
            margin: 40px 0;
        }
        
        .empty-state i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
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
            animation: float-element 20s infinite linear;
        }
        
        @keyframes float-element {
            0% { transform: translateY(100vh) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(360deg); }
        }
        
        .back-btn {
            position: absolute;
            top: 25px;
            left: 25px;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            border: none;
            color: #2c3e50;
            padding: 12px 20px;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            backdrop-filter: blur(10px);
            font-weight: 600;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .back-btn:hover {
            background: linear-gradient(135deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0.2) 100%);
            transform: translateX(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        /* Remove extra scroll bar fixes */
        body {
            overflow-x: hidden;
        }
        
        .container {
            max-width: 100%;
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
        }
        
        @media (max-width: 1200px) {
            .shortlist-grid {
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 25px;
            }
        }
        
        @media (max-width: 992px) {
            .shortlist-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
            
            .shortlist-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 25px;
            }
            
            .shortlist-content {
                padding: 30px 25px;
            }
            
            .section-title {
                font-size: 1.8rem;
            }
            
            .shortlist-grid {
                grid-template-columns: 1fr;
            }
            
            .shortlist-stats {
                grid-template-columns: 1fr;
            }
            
            .shortlist-photo-container {
                width: 140px;
                height: 140px;
                bottom: -70px;
            }
            
            .shortlist-content-area {
                padding: 90px 20px 20px;
            }
            
            .shortlist-header {
                height: 180px;
            }
        }
        
        @media (max-width: 576px) {
            .page-header {
                padding: 25px 20px;
            }
            
            .shortlist-content {
                padding: 25px 20px;
            }
            
            .back-btn {
                top: 15px;
                left: 15px;
                padding: 10px 15px;
                font-size: 0.9rem;
            }
            
            .btn-action {
                padding: 8px 12px;
                font-size: 0.8rem;
            }
            
            .shortlist-actions {
                flex-direction: column;
                gap: 8px;
            }
            
            .btn-action {
                max-width: 100%;
            }
            
            .shortlist-photo-container {
                width: 120px;
                height: 120px;
                bottom: -60px;
            }
            
            .shortlist-content-area {
                padding: 80px 20px 20px;
            }
            
            .shortlist-header {
                height: 160px;
            }
        }
    </style>

    <div class="shortlist-container">
        <!-- Floating Elements -->
        <div class="floating-elements">
            <div class="floating-element" style="width: 80px; height: 80px; top: 15%; left: 5%; animation-delay: 0s;"></div>
            <div class="floating-element" style="width: 120px; height: 120px; top: 25%; right: 8%; animation-delay: 3s;"></div>
            <div class="floating-element" style="width: 60px; height: 60px; bottom: 35%; left: 15%; animation-delay: 6s;"></div>
            <div class="floating-element" style="width: 100px; height: 100px; bottom: 25%; right: 12%; animation-delay: 9s;"></div>
        </div>

        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <button class="back-btn" onclick="goBack()">
                    <i class="fas fa-arrow-left"></i> Go Back
                </button>
                
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="section-title">
                            <i class="fas fa-bookmark text-warning"></i> 
                            My Shortlisted Profiles
                        </h1>
                        <p class="mb-0 text-muted">
                            Your favorite profiles are stored here
                        </p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge bg-light text-dark p-2">
                                📅 <asp:Label ID="lblShortlistCount" runat="server" Text="0"></asp:Label> Profiles
                            </span>
                            <span class="badge bg-warning text-dark p-2">
                                ⭐ Shortlisted
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="shortlist-content">
                <!-- Statistics -->
                <div class="shortlist-stats">
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblTotalShortlisted" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label">Total Shortlisted</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblActiveProfiles" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label">Active Profiles</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblPremiumProfiles" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label">Premium Profiles</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblRecentAdditions" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label">Recently Added</span>
                    </div>
                </div>

                <!-- Shortlisted Profiles Grid -->
                <div class="shortlist-grid">
                    <asp:Repeater ID="rptShortlistedProfiles" runat="server" OnItemDataBound="rptShortlistedProfiles_ItemDataBound">
                        <ItemTemplate>
                            <div class="shortlist-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                <div class="shortlist-header">
                                    <!-- Background Image -->
                                    <img src='<%# Eval("Gender").ToString() == "Female" ? "~/Images/female-bg.jpg" : "~/Images/male-bg.jpg" %>' 
                                         class="shortlist-bg" alt="background" />
                                    
                                    <!-- Profile Photo - Double Size -->
                                    <div class="shortlist-photo-container">
                                        <asp:Image ID="imgProfile" runat="server" CssClass="shortlist-photo" 
                                            ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                            onerror="this.src='Images/default-profile.jpg'" />
                                    </div>
                                    
                                    <!-- Online Status -->
                                    <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>" 
                                        title='<%# (new Random().Next(0,100) > 50 ? "Online" : "Offline") %>'></div>
                                    
                                    <!-- Premium Badge -->
                                    <div class="premium-badge" id="premiumBadge" runat="server" 
                                        style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                        ⭐ Premium
                                    </div>
                                </div>
                                
                                <div class="shortlist-content-area">
                                    <div class="shortlist-name">
                                        <%# Eval("FullName") %>
                                    </div>
                                    <div class="shortlist-age">
                                        <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                    </div>
                                    <div class="shortlist-location">
                                        <i class="fas fa-map-marker-alt text-muted"></i> 
                                        <%# Eval("City") %>, <%# Eval("State") %>
                                    </div>
                                    
                                    <div class="shortlist-tags">
                                        <span class="tag"><%# Eval("Education") %></span>
                                        <span class="tag"><%# Eval("Caste") %></span>
                                        <span class="tag"><%# Eval("Religion") %></span>
                                    </div>
                                    
                                    <div class="shortlist-actions">
                                        <button class="btn-action btn-view" 
                                                onclick='viewProfile(event, <%# Eval("UserID") %>)'>
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button class="btn-action btn-remove" 
                                                onclick='removeFromShortlist(event, <%# Eval("UserID") %>)'>
                                            <i class="fas fa-times"></i> Remove
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <!-- Empty State -->
                <asp:Panel ID="pnlNoShortlisted" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-bookmark fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No profiles shortlisted yet</h4>
                    <p class="text-muted">Go to a profile and click the "Shortlist" button to shortlist your favorite profiles</p>
                    <asp:Button ID="btnBrowseProfiles" runat="server" Text="🔍 Browse Profiles" 
                        CssClass="btn btn-primary mt-3 px-4 py-2" OnClick="btnBrowseProfiles_Click" />
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        function goBack() {
            window.history.back();
        }

        function viewProfile(event, userID) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            console.log('Viewing profile:', userID);
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        function removeFromShortlist(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Do you want to remove this profile from shortlist?')) {
                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Shortlisted.aspx/RemoveFromShortlist",
                    data: JSON.stringify({
                        userID: parseInt(currentUserID),
                        shortlistedUserID: parseInt(userID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('Profile removed from shortlist!', 'success');
                            // Refresh the page after 1 second
                            setTimeout(() => {
                                location.reload();
                            }, 1000);
                        } else {
                            showNotification('Error removing profile!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error removing profile!', 'error');
                    }
                });
            }
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '18px 24px';
            notification.style.borderRadius = '15px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
            notification.style.transition = 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';
            notification.style.maxWidth = '400px';
            notification.style.transform = 'translateX(100px)';
            notification.style.opacity = '0';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, rgba(40, 167, 69, 0.9) 0%, rgba(25, 135, 84, 0.9) 100%)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, rgba(220, 53, 69, 0.9) 0%, rgba(189, 33, 48, 0.9) 100%)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, rgba(23, 162, 184, 0.9) 0%, rgba(12, 99, 112, 0.9) 100%)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            // Animate in
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
                notification.style.opacity = '1';
            }, 100);

            // Remove notification after 4 seconds
            setTimeout(() => {
                notification.style.transform = 'translateX(100px)';
                notification.style.opacity = '0';
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 400);
            }, 4000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Add animations
            const cards = document.querySelectorAll('.shortlist-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</asp:Content>






















<%--<%@ Page Title="Shortlisted Profiles - JivanBandhan" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Shortlisted.aspx.cs" Inherits="JivanBandhan4.Shortlisted" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .shortlist-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #d63384 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .shortlist-container::before {
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
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.15);
            position: relative;
            border: 1px solid rgba(255,255,255,0.3);
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
        
        .shortlist-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        
        .shortlist-content::before {
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
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 2.2rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 100px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        .shortlist-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .stat-number {
            display: block;
            font-size: 2.5rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 1rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .shortlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 25px;
        }
        
        .shortlist-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
        }
        
        .shortlist-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .shortlist-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 60px rgba(0,0,0,0.2);
        }
        
        .shortlist-card:hover::before {
            opacity: 0.3;
        }
        
        .shortlist-header {
            position: relative;
            height: 160px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .shortlist-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.8;
            transition: transform 0.4s ease;
        }
        
        .shortlist-card:hover .shortlist-bg {
            transform: scale(1.1);
        }
        
        .shortlist-photo-container {
            position: absolute;
            bottom: -50px;
            left: 50%;
            transform: translateX(-50%);
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 6px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }
        
        .shortlist-photo-container:hover {
            transform: translateX(-50%) scale(1.15);
            border-color: #d63384;
            box-shadow: 0 20px 50px rgba(214, 51, 132, 0.4);
        }
        
        .shortlist-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        .shortlist-card:hover .shortlist-photo {
            transform: scale(1.1);
        }
        
        .online-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .shortlist-content-area {
            padding: 70px 25px 25px;
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .shortlist-name {
            font-size: 1.4rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .shortlist-age {
            color: #d63384;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .shortlist-location {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .shortlist-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin-bottom: 20px;
        }
        
        .tag {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            color: #495057;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        
        .tag:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .shortlist-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            max-width: 120px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-action:hover::before {
            left: 100%;
        }
        
        .btn-view {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-remove {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 30px;
            color: #6c757d;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 25px;
            border: 2px dashed rgba(108, 117, 125, 0.3);
            margin: 40px 0;
        }
        
        .empty-state i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
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
            animation: float-element 20s infinite linear;
        }
        
        @keyframes float-element {
            0% { transform: translateY(100vh) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(360deg); }
        }
        
        .back-btn {
            position: absolute;
            top: 25px;
            left: 25px;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            border: none;
            color: #2c3e50;
            padding: 12px 20px;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            backdrop-filter: blur(10px);
            font-weight: 600;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .back-btn:hover {
            background: linear-gradient(135deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0.2) 100%);
            transform: translateX(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        @media (max-width: 1200px) {
            .shortlist-grid {
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 25px;
            }
        }
        
        @media (max-width: 992px) {
            .shortlist-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
            
            .shortlist-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 25px;
            }
            
            .shortlist-content {
                padding: 30px 25px;
            }
            
            .section-title {
                font-size: 1.8rem;
            }
            
            .shortlist-grid {
                grid-template-columns: 1fr;
            }
            
            .shortlist-stats {
                grid-template-columns: 1fr;
            }
            
            .shortlist-photo-container {
                width: 100px;
                height: 100px;
                bottom: -40px;
            }
            
            .shortlist-content-area {
                padding: 60px 20px 20px;
            }
        }
        
        @media (max-width: 576px) {
            .page-header {
                padding: 25px 20px;
            }
            
            .shortlist-content {
                padding: 25px 20px;
            }
            
            .back-btn {
                top: 15px;
                left: 15px;
                padding: 10px 15px;
                font-size: 0.9rem;
            }
            
            .btn-action {
                padding: 8px 12px;
                font-size: 0.8rem;
            }
            
            .shortlist-actions {
                flex-direction: column;
                gap: 8px;
            }
            
            .btn-action {
                max-width: 100%;
            }
        }
    </style>

    <div class="shortlist-container">
        <!-- Floating Elements -->
        <div class="floating-elements">
            <div class="floating-element" style="width: 80px; height: 80px; top: 15%; left: 5%; animation-delay: 0s;"></div>
            <div class="floating-element" style="width: 120px; height: 120px; top: 25%; right: 8%; animation-delay: 3s;"></div>
            <div class="floating-element" style="width: 60px; height: 60px; bottom: 35%; left: 15%; animation-delay: 6s;"></div>
            <div class="floating-element" style="width: 100px; height: 100px; bottom: 25%; right: 12%; animation-delay: 9s;"></div>
        </div>

        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <button class="back-btn marathi-font" onclick="goBack()">
                    <i class="fas fa-arrow-left"></i> मागे जा
                </button>
                
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="section-title marathi-font">
                            <i class="fas fa-bookmark text-warning"></i> 
                            माझे शॉर्टलिस्ट केलेले प्रोफाइल
                        </h1>
                        <p class="marathi-font mb-0 text-muted">
                            तुमच्या आवडीचे प्रोफाइल येथे संग्रहित केलेले आहेत
                        </p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge bg-light text-dark marathi-font p-2">
                                📅 <asp:Label ID="lblShortlistCount" runat="server" Text="0"></asp:Label> प्रोफाइल
                            </span>
                            <span class="badge bg-warning text-dark marathi-font p-2">
                                ⭐ शॉर्टलिस्ट
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="shortlist-content">
                <!-- Statistics -->
                <div class="shortlist-stats">
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblTotalShortlisted" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label marathi-font">एकूण शॉर्टलिस्ट</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblActiveProfiles" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label marathi-font">सक्रिय प्रोफाइल</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblPremiumProfiles" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label marathi-font">प्रीमियम प्रोफाइल</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number"><asp:Label ID="lblRecentAdditions" runat="server" Text="0"></asp:Label></span>
                        <span class="stat-label marathi-font">नवीन जोडले</span>
                    </div>
                </div>

                <!-- Shortlisted Profiles Grid -->
                <div class="shortlist-grid">
                    <asp:Repeater ID="rptShortlistedProfiles" runat="server" OnItemDataBound="rptShortlistedProfiles_ItemDataBound">
                        <ItemTemplate>
                            <div class="shortlist-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                <div class="shortlist-header">
                                    <!-- Background Image -->
                                    <img src='<%# Eval("Gender").ToString() == "स्त्री" ? "~/Images/female-bg.jpg" : "~/Images/male-bg.jpg" %>' 
                                         class="shortlist-bg" alt="background" />
                                    
                                    <!-- Profile Photo -->
                                    <div class="shortlist-photo-container">
                                        <asp:Image ID="imgProfile" runat="server" CssClass="shortlist-photo" 
                                            ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                            onerror="this.src='Images/default-profile.jpg'" />
                                    </div>
                                    
                                    <!-- Online Status -->
                                    <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>" 
                                        title='<%# (new Random().Next(0,100) > 50 ? "Online" : "Offline") %>'></div>
                                    
                                    <!-- Premium Badge -->
                                    <div class="premium-badge" id="premiumBadge" runat="server" 
                                        style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                        ⭐ Premium
                                    </div>
                                </div>
                                
                                <div class="shortlist-content-area">
                                    <div class="shortlist-name marathi-font">
                                        <%# Eval("FullName") %>
                                    </div>
                                    <div class="shortlist-age marathi-font">
                                        <!-- CalculateAge inline implementation -->
                                        <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> वर्षे | <%# Eval("Occupation") %>
                                    </div>
                                    <div class="shortlist-location marathi-font">
                                        <i class="fas fa-map-marker-alt text-muted"></i> 
                                        <%# Eval("City") %>, <%# Eval("State") %>
                                    </div>
                                    
                                    <div class="shortlist-tags">
                                        <span class="tag marathi-font"><%# Eval("Education") %></span>
                                        <span class="tag marathi-font"><%# Eval("Caste") %></span>
                                        <span class="tag marathi-font"><%# Eval("Religion") %></span>
                                    </div>
                                    
                                    <div class="shortlist-actions">
                                        <button class="btn-action btn-view marathi-font" 
                                                onclick='viewProfile(event, <%# Eval("UserID") %>)'>
                                            <i class="fas fa-eye"></i> पाहा
                                        </button>
                                        <button class="btn-action btn-remove marathi-font" 
                                                onclick='removeFromShortlist(event, <%# Eval("UserID") %>)'>
                                            <i class="fas fa-times"></i> काढा
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <!-- Empty State -->
                <asp:Panel ID="pnlNoShortlisted" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-bookmark fa-4x text-muted mb-3"></i>
                    <h4 class="marathi-font text-muted">अजून कोणतेही प्रोफाइल शॉर्टलिस्ट केलेले नाहीत</h4>
                    <p class="marathi-font text-muted">तुम्हाला आवडणारे प्रोफाइल शॉर्टलिस्ट करण्यासाठी प्रोफाइलवर जा आणि "शॉर्टलिस्ट करा" बटण क्लिक करा</p>
                    <asp:Button ID="btnBrowseProfiles" runat="server" Text="🔍 प्रोफाइल ब्राउझ करा" 
                        CssClass="btn btn-primary marathi-font mt-3 px-4 py-2" OnClick="btnBrowseProfiles_Click" />
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        function goBack() {
            window.history.back();
        }

        function viewProfile(event, userID) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            console.log('Viewing profile:', userID);
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        function removeFromShortlist(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('तुम्हाला हे प्रोफाइल शॉर्टलिस्टमधून काढू इच्छिता?')) {
                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Shortlisted.aspx/RemoveFromShortlist",
                    data: JSON.stringify({
                        userID: parseInt(currentUserID),
                        shortlistedUserID: parseInt(userID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('प्रोफाइल शॉर्टलिस्टमधून काढले!', 'success');
                            // Refresh the page after 1 second
                            setTimeout(() => {
                                location.reload();
                            }, 1000);
                        } else {
                            showNotification('प्रोफाइल काढताना त्रुटी!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('प्रोफाइल काढताना त्रुटी!', 'error');
                    }
                });
            }
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '18px 24px';
            notification.style.borderRadius = '15px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
            notification.style.transition = 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';
            notification.style.maxWidth = '400px';
            notification.style.transform = 'translateX(100px)';
            notification.style.opacity = '0';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, rgba(40, 167, 69, 0.9) 0%, rgba(25, 135, 84, 0.9) 100%)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, rgba(220, 53, 69, 0.9) 0%, rgba(189, 33, 48, 0.9) 100%)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, rgba(23, 162, 184, 0.9) 0%, rgba(12, 99, 112, 0.9) 100%)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            // Animate in
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
                notification.style.opacity = '1';
            }, 100);

            // Remove notification after 4 seconds
            setTimeout(() => {
                notification.style.transform = 'translateX(100px)';
                notification.style.opacity = '0';
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 400);
            }, 4000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Add animations
            const cards = document.querySelectorAll('.shortlist-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Add parallax effect
            window.addEventListener('scroll', function () {
                const scrolled = window.pageYOffset;
                const parallax = document.querySelector('.shortlist-container::before');
                if (parallax) {
                    parallax.style.transform = `translateY(${scrolled * 0.5}px)`;
                }
            });
        });
    </script>
</asp:Content>--%>