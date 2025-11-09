<%@ Page Title="Marathi Matrimony - Interests" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Interests.aspx.cs" Inherits="JivanBandhan4.Interests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /* Main Container Styles */
        .interests-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .page-header {
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            color: white;
            border-radius: 20px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: rgba(255,255,255,0.1);
            transform: rotate(45deg);
        }
        
        /* Tab Container Styles */
        .tab-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .tab-header {
            display: flex;
            background: #f8f9fa;
            border-bottom: 2px solid #e9ecef;
            position: relative;
        }
        
        .tab-button {
            flex: 1;
            padding: 20px;
            text-align: center;
            background: none;
            border: none;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #6c757d;
            border-bottom: 3px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .tab-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s;
        }
        
        .tab-button:hover::before {
            left: 100%;
        }
        
        .tab-button.active {
            color: #8B0000;
            border-bottom-color: #8B0000;
            background: white;
        }
        
        .tab-button:hover {
            color: #8B0000;
            background: rgba(139, 0, 0, 0.05);
        }
        
        .tab-content {
            padding: 30px;
            display: none;
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .tab-content.active {
            display: block;
        }
        
        /* Interest Card Styles */
        .interest-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border-left: 4px solid #8B0000;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }
        
        .interest-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(139, 0, 0, 0.03), transparent);
            transition: left 0.6s;
        }
        
        .interest-card:hover::before {
            left: 100%;
        }
        
        .interest-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-left-color: #B22222;
        }
        
        .interest-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .interest-card:hover .interest-avatar {
            transform: scale(1.1);
            border-color: #8B0000;
        }
        
        .interest-content {
            flex: 1;
            position: relative;
            z-index: 2;
        }
        
        .interest-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }
        
        .interest-user-info h4 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.3rem;
            font-weight: 600;
        }
        
        .interest-user-details {
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 5px;
            line-height: 1.4;
        }
        
        .interest-meta {
            text-align: right;
        }
        
        .interest-time {
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 8px;
        }
        
        .interest-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        /* Button Styles */
        .btn-interest-action {
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            position: relative;
            overflow: hidden;
        }
        
        .btn-interest-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s;
        }
        
        .btn-interest-action:hover::before {
            left: 100%;
        }
        
        .btn-accept {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .btn-reject {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
        }
        
        .btn-withdraw {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .btn-view-profile {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        
        .btn-resend {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
        }
        
        .btn-interest-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        /* Status Badges */
        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .status-accepted {
            background: linear-gradient(135deg, #d1edff 0%, #a8d5ff 100%);
            color: #004085;
            border: 1px solid #a8d5ff;
        }
        
        .status-rejected {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        /* Stats Overview */
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border-top: 4px solid #8B0000;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(139, 0, 0, 0.03), transparent);
            transition: left 0.6s;
        }
        
        .stat-card:hover::before {
            left: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #8B0000;
            display: block;
            line-height: 1;
            margin-bottom: 8px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        /* Clickable Area - ENHANCED */
        .interest-clickable-area {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0; /* Changed to cover entire card */
            cursor: pointer;
            z-index: 1;
        }
        
        .profile-click-hint {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(139, 0, 0, 0.9);
            color: white;
            padding: 4px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 2;
        }
        
        .interest-card:hover .profile-click-hint {
            opacity: 1;
        }
        
        /* Loading Animation */
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #8B0000;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;
            vertical-align: middle;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Notification Styles */
        .custom-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 10px;
            color: white;
            font-weight: bold;
            z-index: 10000;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            max-width: 300px;
            transform: translateX(400px);
            opacity: 0;
        }
        
        .custom-notification.show {
            transform: translateX(0);
            opacity: 1;
        }
        
        .notification-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .notification-error {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }
        
        .notification-info {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        }
        
        .notification-warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .interest-card {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            
            .interest-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            
            .interest-meta {
                text-align: center;
                margin-top: 10px;
            }
            
            .interest-actions {
                justify-content: center;
            }
            
            .tab-button {
                padding: 15px 10px;
                font-size: 0.9rem;
            }
            
            .stats-overview {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }
            
            .stat-card {
                padding: 20px 15px;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }
        
        @media (max-width: 480px) {
            .stats-overview {
                grid-template-columns: 1fr;
            }
            
            .interest-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-interest-action {
                width: 200px;
                margin-bottom: 5px;
            }
            
            .tab-header {
                flex-direction: column;
            }
            
            .tab-button {
                padding: 12px;
            }
        }
        
        /* Back Button */
        .btn-back {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
        }
        
        /* Animation for new interests */
        @keyframes highlight {
            0% { background-color: rgba(139, 0, 0, 0.1); }
            100% { background-color: transparent; }
        }
        
        .new-interest {
            animation: highlight 2s ease-in-out;
        }
        
        /* Enhanced profile info */
        .profile-gender-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 8px;
            vertical-align: middle;
        }
        
        .gender-male {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        
        .gender-female {
            background: linear-gradient(135deg, #e83e8c 0%, #d91a72 100%);
            color: white;
        }
    </style>

    <div class="interests-container">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1>💝 Interests</h1>
                        <p class="mb-0">Interests you have received and sent</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBackToDashboard" runat="server" Text="🏠 Back to Dashboard" 
                            CssClass="btn btn-light" OnClick="btnBackToDashboard_Click" />
                    </div>
                </div>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <span class="stat-number"><asp:Label ID="lblTotalReceived" runat="server" Text="0"></asp:Label></span>
                    <span class="stat-label">Received Interests</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><asp:Label ID="lblTotalSent" runat="server" Text="0"></asp:Label></span>
                    <span class="stat-label">Sent Interests</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><asp:Label ID="lblAccepted" runat="server" Text="0"></asp:Label></span>
                    <span class="stat-label">Accepted</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><asp:Label ID="lblPending" runat="server" Text="0"></asp:Label></span>
                    <span class="stat-label">Pending</span>
                </div>
            </div>

            <!-- Tab Container -->
            <div class="tab-container">
                <!-- Tab Header -->
                <div class="tab-header">
                    <button class="tab-button active" onclick="switchTab('received')">
                        📥 Received Interests (<span id="receivedCount"><asp:Label ID="lblReceivedCount" runat="server" Text="0"></asp:Label></span>)
                    </button>
                    <button class="tab-button" onclick="switchTab('sent')">
                        📤 Sent Interests (<span id="sentCount"><asp:Label ID="lblSentCount" runat="server" Text="0"></asp:Label></span>)
                    </button>
                </div>

                <!-- Received Interests Tab -->
                <div id="received-tab" class="tab-content active">
                    <h3 class="mb-4" style="color: #8B0000;">
                        <i class="fas fa-inbox"></i> Interests You've Received
                        <small class="text-muted" style="font-size: 1rem;">
                            (From members of opposite gender who have shown interest in you)
                        </small>
                    </h3>
                    
                    <asp:Repeater ID="rptReceivedInterests" runat="server" OnItemDataBound="rptReceivedInterests_ItemDataBound">
                        <ItemTemplate>
                            <div class="interest-card" data-interestid='<%# Eval("InterestID") %>' 
                                onclick='viewProfile(<%# Eval("SentByUserID") %>)'>
                                <!-- Clickable area for entire profile card -->
                                <div class="interest-clickable-area"></div>
                                <div class="profile-click-hint">👆 View Profile</div>
                                
                                <div class="interest-content">
                                    <div class="interest-header">
                                        <div class="interest-user-info">
                                            <div class="d-flex align-items-center">
                                                <asp:Image ID="imgUser" runat="server" CssClass="interest-avatar" 
                                                    ImageUrl='<%# GetUserPhotoUrl(Eval("SentByUserID")) %>'
                                                    onerror="this.src='Images/default-profile.png'" />
                                                <div class="ms-3">
                                                    <h4 class="mb-1">
                                                        <%# Eval("FullName") %>
                                                        <span class='profile-gender-badge gender-<%# Eval("Gender").ToString().ToLower() %>'>
                                                            <%# Eval("Gender") %>
                                                        </span>
                                                    </h4>
                                                    <div class="interest-user-details">
                                                        <%# CalculateAge(Eval("DateOfBirth")) %> Years | <%# Eval("Occupation") %> | <%# Eval("City") %>, <%# Eval("State") %>
                                                    </div>
                                                    <div class="interest-user-details text-success">
                                                        <small>📅 Interest sent on <%# FormatDate(Eval("SentDate")) %></small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="interest-meta">
                                            <div class="status-badge <%# GetStatusClass(Eval("Status")) %>">
                                                <asp:Label ID="lblStatus" runat="server" Text='<%# GetStatusText(Eval("Status")) %>'></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="interest-actions" onclick="event.stopPropagation()">
                                        <asp:Button ID="btnViewProfile" runat="server" Text="👁️ View Profile" 
                                            CssClass="btn-interest-action btn-view-profile" 
                                            CommandArgument='<%# Eval("SentByUserID") %>' 
                                            OnClientClick='viewProfile(<%# Eval("SentByUserID") %>); return false;' />
                                        
                                        <asp:Button ID="btnAccept" runat="server" Text="✅ Accept" 
                                            CssClass="btn-interest-action btn-accept" 
                                            CommandArgument='<%# Eval("InterestID") %>' 
                                            OnClick="btnAccept_Click" 
                                            Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                                        
                                        <asp:Button ID="btnReject" runat="server" Text="❌ Reject" 
                                            CssClass="btn-interest-action btn-reject" 
                                            CommandArgument='<%# Eval("InterestID") %>' 
                                            OnClick="btnReject_Click" 
                                            Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                                        
                                        <asp:Button ID="btnSendMessage" runat="server" Text="💌 Send Message" 
                                            CssClass="btn-interest-action btn-view-profile" 
                                            CommandArgument='<%# Eval("SentByUserID") %>' 
                                            OnClick="btnSendMessage_Click" 
                                            Visible='<%# Eval("Status").ToString() == "Accepted" %>' />
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoReceivedInterests" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No interests received yet</h4>
                        <p class="text-muted">When someone shows interest in you, it will appear here</p>
                        <asp:Button ID="btnImproveProfile" runat="server" Text="📈 Improve Profile" 
                            CssClass="btn btn-primary mt-2" OnClick="btnImproveProfile_Click" />
                    </asp:Panel>
                </div>

                <!-- Sent Interests Tab -->
                <div id="sent-tab" class="tab-content">
                    <h3 class="mb-4" style="color: #8B0000;">
                        <i class="fas fa-paper-plane"></i> Interests You've Sent
                        <small class="text-muted" style="font-size: 1rem;">
                            (To members of opposite gender you have shown interest in)
                        </small>
                    </h3>
                    
                    <asp:Repeater ID="rptSentInterests" runat="server" OnItemDataBound="rptSentInterests_ItemDataBound">
                        <ItemTemplate>
                            <div class="interest-card" data-interestid='<%# Eval("InterestID") %>'
                                onclick='viewProfile(<%# Eval("TargetUserID") %>)'>
                                <!-- Clickable area for entire profile card -->
                                <div class="interest-clickable-area"></div>
                                <div class="profile-click-hint">👆 View Profile</div>
                                
                                <div class="interest-content">
                                    <div class="interest-header">
                                        <div class="interest-user-info">
                                            <div class="d-flex align-items-center">
                                                <asp:Image ID="imgUser" runat="server" CssClass="interest-avatar" 
                                                    ImageUrl='<%# GetUserPhotoUrl(Eval("TargetUserID")) %>'
                                                    onerror="this.src='Images/default-profile.png'" />
                                                <div class="ms-3">
                                                    <h4 class="mb-1">
                                                        <%# Eval("FullName") %>
                                                        <span class='profile-gender-badge gender-<%# Eval("Gender").ToString().ToLower() %>'>
                                                            <%# Eval("Gender") %>
                                                        </span>
                                                    </h4>
                                                    <div class="interest-user-details">
                                                        <%# CalculateAge(Eval("DateOfBirth")) %> Years | <%# Eval("Occupation") %> | <%# Eval("City") %>, <%# Eval("State") %>
                                                    </div>
                                                    <div class="interest-user-details text-info">
                                                        <small>📅 Interest sent on <%# FormatDate(Eval("SentDate")) %></small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="interest-meta">
                                            <div class='status-badge <%# GetStatusClass(Eval("Status")) %>'>
                                                <%# GetStatusText(Eval("Status")) %>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="interest-actions" onclick="event.stopPropagation()">
                                        <asp:Button ID="btnViewProfile" runat="server" Text="👁️ View Profile" 
                                            CssClass="btn-interest-action btn-view-profile" 
                                            CommandArgument='<%# Eval("TargetUserID") %>' 
                                            OnClientClick='viewProfile(<%# Eval("TargetUserID") %>); return false;' />
                                        
                                        <asp:Button ID="btnWithdraw" runat="server" Text="🗑️ Withdraw" 
                                            CssClass="btn-interest-action btn-withdraw" 
                                            CommandArgument='<%# Eval("InterestID") %>' 
                                            OnClick="btnWithdraw_Click" 
                                            Visible='<%# Eval("Status").ToString() == "Pending" %>' 
                                            OnClientClick='return confirmWithdraw(this, <%# Eval("InterestID") %>);' />
                                        
                                        <asp:Button ID="btnResend" runat="server" Text="🔄 Resend" 
                                            CssClass="btn-interest-action btn-resend" 
                                            CommandArgument='<%# Eval("TargetUserID") %>' 
                                            OnClick="btnResend_Click" 
                                            Visible='<%# Eval("Status").ToString() == "Rejected" %>' />
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoSentInterests" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-paper-plane fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">You haven't sent any interests yet</h4>
                        <p class="text-muted">Find a partner and make contact by showing interest</p>
                        <asp:Button ID="btnFindMatches" runat="server" Text="🔍 Find Matches" 
                            CssClass="btn btn-primary mt-3" OnClick="btnFindMatches_Click" />
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    
    <script>
        // View profile function - ENHANCED
        function viewProfile(userID) {
            console.log('Viewing opposite gender profile:', userID);
            
            // Track profile view from interests
            trackProfileView(userID);
            
            // Redirect to profile page
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID + '&from=interests';
        }

        // Track profile view from interests
        function trackProfileView(viewedUserID) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Interests.aspx/TrackProfileView",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    viewedUserID: parseInt(viewedUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Profile view tracked from interests:', response.d);
                },
                error: function (xhr, status, error) {
                    console.log('Error tracking profile view:', error);
                }
            });
        }

        // Tab switching functionality
        function switchTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });

            // Remove active class from all buttons
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('active');
            });

            // Show selected tab
            document.getElementById(tabName + '-tab').classList.add('active');

            // Activate selected button
            event.target.classList.add('active');
            
            // Save active tab to session storage
            sessionStorage.setItem('activeInterestsTab', tabName);
        }

        // Enhanced confirmation for withdraw
        function confirmWithdraw(button, interestID) {
            if (confirm('Are you sure you want to withdraw this interest? This action cannot be undone.')) {
                showButtonLoading(button, 'Withdrawing...');
                return true;
            }
            return false;
        }

        // Show loading state on button
        function showButtonLoading(button, text) {
            const originalText = button.innerHTML;
            button.innerHTML = `<span class="loading-spinner"></span>${text}`;
            button.disabled = true;
            
            // Revert after 3 seconds if still loading
            setTimeout(() => {
                if (button.disabled) {
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }, 3000);
        }

        // Notification function
        function showNotification(message, type) {
            // Remove existing notifications
            $('.custom-notification').remove();
            
            const notification = document.createElement('div');
            notification.className = `custom-notification notification-${type}`;
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas ${getNotificationIcon(type)} me-2"></i>
                    <span>${message}</span>
                </div>
            `;
            
            document.body.appendChild(notification);
            
            // Show notification with animation
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);

            // Auto remove after 5 seconds
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 300);
            }, 5000);
        }

        function getNotificationIcon(type) {
            switch(type) {
                case 'success': return 'fa-check-circle';
                case 'error': return 'fa-exclamation-circle';
                case 'warning': return 'fa-exclamation-triangle';
                default: return 'fa-info-circle';
            }
        }

        // Refresh interests count
        function refreshInterestsCount() {
            console.log('Refreshing interest counts...');
            // Could implement AJAX refresh here if needed
        }

        // Handle AJAX responses
        function handleAjaxResponse(response, successMessage, errorMessage) {
            if (response && response.d === "success") {
                showNotification(successMessage, 'success');
                // Reload after delay
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                showNotification(errorMessage, 'error');
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            console.log('Interests page loaded');
            
            // Add hover effects to interest cards
            const cards = document.querySelectorAll('.interest-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-5px)';
                });

                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Restore active tab from session storage
            const activeTab = sessionStorage.getItem('activeInterestsTab');
            if (activeTab && activeTab !== 'received') {
                // Simulate click on the tab button
                const tabButton = document.querySelector(`.tab-button:nth-child(${activeTab === 'sent' ? 2 : 1})`);
                if (tabButton) {
                    tabButton.click();
                }
            }

            // Add animation to new interests
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('newInterest') === 'true') {
                const interests = document.querySelectorAll('.interest-card');
                if (interests.length > 0) {
                    interests[0].classList.add('new-interest');
                }
            }

            // Auto-refresh counts every 30 seconds if there are pending interests
            const pendingInterests = document.querySelectorAll('.status-pending');
            if (pendingInterests.length > 0) {
                setInterval(refreshInterestsCount, 30000);
            }

            // Enhanced click effects for entire cards
            cards.forEach(card => {
                card.addEventListener('click', function(e) {
                    // Don't trigger if clicking on actions area
                    if (!e.target.closest('.interest-actions')) {
                        const userID = this.getAttribute('data-userid') || 
                                     this.querySelector('.btn-view-profile')?.getAttribute('commandargument');
                        if (userID) {
                            viewProfile(userID);
                        }
                    }
                });
            });

            // Add ripple effect to cards
            cards.forEach(card => {
                card.addEventListener('click', function(e) {
                    if (!e.target.closest('.interest-actions')) {
                        const ripple = document.createElement('span');
                        const rect = this.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        const x = e.clientX - rect.left - size / 2;
                        const y = e.clientY - rect.top - size / 2;
                        
                        ripple.style.cssText = `
                            position: absolute;
                            border-radius: 50%;
                            background: rgba(139, 0, 0, 0.3);
                            transform: scale(0);
                            animation: ripple 0.6s linear;
                            width: ${size}px;
                            height: ${size}px;
                            left: ${x}px;
                            top: ${y}px;
                            pointer-events: none;
                            z-index: 1;
                        `;
                        
                        this.appendChild(ripple);
                        
                        setTimeout(() => {
                            ripple.remove();
                        }, 600);
                    }
                });
            });

            // Add keyframe for ripple effect
            if (!document.querySelector('#ripple-style')) {
                const style = document.createElement('style');
                style.id = 'ripple-style';
                style.textContent = `
                    @keyframes ripple {
                        to {
                            transform: scale(4);
                            opacity: 0;
                        }
                    }
                `;
                document.head.appendChild(style);
            }

            // Load current user gender for display
            loadCurrentUserInfo();
        });

        // Load current user information
        function loadCurrentUserInfo() {
            const currentUserGender = document.getElementById('<%= hdnCurrentUserGender.ClientID %>')?.value;
            console.log('Current user gender:', currentUserGender);

            // You can use this information to customize the display
            if (currentUserGender) {
                document.body.setAttribute('data-user-gender', currentUserGender.toLowerCase());
            }
        }

        // Handle network errors
        function handleNetworkError(error) {
            console.error('Network error:', error);
            showNotification('Network error! Please check your internet connection.', 'error');
        }

        // Debounce function for performance
        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }

        // Optimized resize handler
        const handleResize = debounce(function () {
            if (window.innerWidth < 768) {
                document.querySelectorAll('.interest-header').forEach(header => {
                    header.style.flexDirection = 'column';
                    header.style.alignItems = 'center';
                    header.style.textAlign = 'center';
                });
            }
        }, 250);

        window.addEventListener('resize', handleResize);
    </script>
</asp:Content>