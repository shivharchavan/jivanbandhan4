<%@ Page Title="Marathi Matrimony - Profile Views" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="TotalViews.aspx.cs" Inherits="JivanBandhan4.TotalViews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
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
        
        .views-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .view-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .view-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        
        .viewer-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .viewer-photo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
        }
        
        .viewer-details {
            flex: 1;
        }
        
        .viewer-name {
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .viewer-meta {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }
        
        .view-time {
            background: rgba(255,255,255,0.1);
            padding: 8px 12px;
            border-radius: 15px;
            color: rgba(255,255,255,0.9);
            font-size: 0.8rem;
            display: inline-block;
            margin-top: 10px;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }
        
        .btn-small {
            padding: 8px 15px;
            border: none;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            backdrop-filter: blur(10px);
        }
        
        .btn-view-profile {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }
        
        .btn-send-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
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
    </style>

    <div class="profile-views-container">
        <div class="container">
            <!-- Back Button -->
            <a href="Dashboard.aspx" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            
            <!-- Page Header -->
            <div class="page-header glass-effect">
                <h1 style="color: white; margin-bottom: 10px;">
                    <i class="fas fa-eye"></i> Your Profile Views
                </h1>
                <p style="color: rgba(255,255,255,0.9); margin-bottom: 0;">
                    See who viewed your profile
                </p>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="totalViewsCount" runat="server">0</span>
                    <span class="stat-label">Total Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="todayViewsCount" runat="server">0</span>
                    <span class="stat-label">Today's Views</span>
                </div>
                <div class="stat-item glass-effect">
                    <span class="stat-number" id="weekViewsCount" runat="server">0</span>
                    <span class="stat-label">Last 7 Days Views</span>
                </div>
            </div>

            <!-- Profile Views Grid -->
            <div class="glass-effect" style="padding: 25px;">
                <h3 style="color: white; margin-bottom: 20px; border-bottom: 2px solid rgba(255,255,255,0.3); padding-bottom: 10px;">
                    <i class="fas fa-users"></i> Users Who Viewed Your Profile
                </h3>
                
                <div class="views-grid">
                    <asp:Repeater ID="rptProfileViews" runat="server" OnItemDataBound="rptProfileViews_ItemDataBound">
                        <ItemTemplate>
                            <div class="view-card" onclick='viewProfile(<%# Eval("ViewerUserID") %>)'>
                                <div class="viewer-info">
                                    <asp:Image ID="imgViewer" runat="server" CssClass="viewer-photo" 
                                        ImageUrl='<%# "~/Uploads/" + Eval("ViewerUserID") + "/profile.jpg" %>'
                                        onerror="this.src='Images/default-profile.jpg'" />
                                    <div class="viewer-details">
                                        <div class="viewer-name">
                                            <%# Eval("ViewerName") %>
                                        </div>
                                        <div class="viewer-meta">
                                            <asp:Literal ID="ltViewerAge" runat="server"></asp:Literal> Years | <%# Eval("ViewerOccupation") %>
                                        </div>
                                        <div class="viewer-meta">
                                            <i class="fas fa-map-marker-alt"></i> <%# Eval("ViewerCity") %>, <%# Eval("ViewerState") %>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="view-time">
                                    <i class="far fa-clock"></i> <%# GetTimeAgo(Convert.ToDateTime(Eval("ViewDate"))) %>
                                </div>
                                
                                <div class="action-buttons">
                                    <button class="btn-small btn-view-profile" 
                                        onclick='viewProfile(event, <%# Eval("ViewerUserID") %>)'>
                                        <i class="fas fa-user"></i> View Profile
                                    </button>
                                    <button class="btn-small btn-send-interest" 
                                        onclick='sendInterest(event, <%# Eval("ViewerUserID") %>)'>
                                        <i class="fas fa-heart"></i> Send Interest
                                    </button>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <asp:Panel ID="pnlNoViews" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-eye-slash fa-3x mb-3"></i>
                    <h4>No one has viewed your profile yet</h4>
                    <p>More people can view your profile if you use it actively</p>
                </asp:Panel>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        function viewProfile(event, userID) {
            event.stopPropagation();
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you interested in this profile?')) {
                const button = event.target.closest('.btn-send-interest') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = '<%= Session["UserID"] != null ? Session["UserID"].ToString() : "0" %>';

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