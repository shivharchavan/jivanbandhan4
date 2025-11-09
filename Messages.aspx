<%@ Page Title="Marathi Matrimony - Messages" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="JivanBandhan4.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .messages-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            color: white;
            border-radius: 20px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .messages-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 25px;
            height: 70vh;
        }
        
        .conversations-sidebar {
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
        }
        
        .conversations-header {
            padding: 20px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .search-box {
            position: relative;
            margin-bottom: 15px;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            border-color: #8B0000;
            box-shadow: 0 0 0 0.2rem rgba(139, 0, 0, 0.25);
        }
        
        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .conversations-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px 0;
        }
        
        .conversation-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #f8f9fa;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .conversation-item:hover {
            background: #f8f9fa;
        }
        
        .conversation-item.active {
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            color: white;
        }
        
        .conversation-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .conversation-avatar:hover {
            border-color: #8B0000;
            transform: scale(1.1);
        }
        
        .conversation-content {
            flex: 1;
            min-width: 0;
        }
        
        .conversation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        
        .conversation-name {
            font-weight: 600;
            font-size: 1rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #2c3e50;
        }

        .conversation-name:hover {
            color: #8B0000;
            text-decoration: underline;
        }
        
        .conversation-item.active .conversation-name {
            color: white;
        }

        .conversation-item.active .conversation-name:hover {
            color: rgba(255,255,255,0.9);
        }
        
        .conversation-time {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .conversation-item.active .conversation-time {
            color: rgba(255,255,255,0.8);
        }
        
        .conversation-preview {
            font-size: 0.85rem;
            color: #6c757d;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .conversation-item.active .conversation-preview {
            color: rgba(255,255,255,0.9);
        }
        
        .unread-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
        }
        
        .chat-area {
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
        }
        
        .chat-header {
            padding: 20px;
            border-bottom: 2px solid #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .chat-user-info {
            display: flex;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 10px;
            border-radius: 15px;
            flex: 1;
        }

        .chat-user-info:hover {
            background: #f8f9fa;
        }
        
        .chat-user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .chat-user-avatar:hover {
            border-color: #8B0000;
            transform: scale(1.1);
        }
        
        .chat-user-details h5 {
            margin: 0;
            color: #2c3e50;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .chat-user-details h5:hover {
            color: #8B0000;
            text-decoration: underline;
        }
        
        .chat-user-details p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .chat-actions {
            display: flex;
            gap: 10px;
        }
        
        .chat-action-btn {
            background: none;
            border: none;
            color: #6c757d;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 5px;
            border-radius: 5px;
        }
        
        .chat-action-btn:hover {
            color: #8B0000;
            background: #f8f9fa;
        }

        .profile-view-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 8px 15px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .profile-view-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        
        .messages-container-scroll {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
            background: #f8f9fa;
        }
        
        .message {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 18px;
            position: relative;
            word-wrap: break-word;
        }
        
        .message-sent {
            align-self: flex-end;
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            color: white;
            border-bottom-right-radius: 5px;
        }
        
        .message-received {
            align-self: flex-start;
            background: white;
            color: #2c3e50;
            border: 1px solid #e9ecef;
            border-bottom-left-radius: 5px;
        }
        
        .message-time {
            font-size: 0.7rem;
            margin-top: 5px;
            opacity: 0.7;
            text-align: right;
        }
        
        .message-received .message-time {
            text-align: left;
        }
        
        .message-input-area {
            padding: 20px;
            border-top: 2px solid #f8f9fa;
            background: white;
            border-bottom-left-radius: 20px;
            border-bottom-right-radius: 20px;
        }
        
        .message-input-container {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        
        .message-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            resize: none;
            font-family: inherit;
            font-size: 0.9rem;
            max-height: 120px;
            transition: all 0.3s ease;
        }
        
        .message-input:focus {
            border-color: #8B0000;
            box-shadow: 0 0 0 0.2rem rgba(139, 0, 0, 0.25);
        }
        
        .send-btn {
            background: linear-gradient(135deg, #8B0000 0%, #B22222 100%);
            color: white;
            border: none;
            border-radius: 50%;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1.2rem;
        }
        
        .send-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(139, 0, 0, 0.4);
        }
        
        .send-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .empty-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            text-align: center;
            padding: 40px;
        }
        
        .empty-chat i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .online-status {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #51cf66;
            margin-left: 5px;
            display: inline-block;
        }

        /* View Profile Link in Messages */
        .view-profile-link {
            color: #8B0000;
            cursor: pointer;
            text-decoration: underline;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .view-profile-link:hover {
            color: #B22222;
            text-decoration: none;
        }

        .conversation-profile-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            border-radius: 15px;
            padding: 5px 10px;
            font-size: 0.7rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-left: 10px;
            white-space: nowrap;
        }

        .conversation-profile-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
        }
        
        @media (max-width: 768px) {
            .messages-layout {
                grid-template-columns: 1fr;
                height: auto;
            }
            
            .conversations-sidebar {
                height: 300px;
            }
            
            .message {
                max-width: 85%;
            }

            .chat-actions {
                flex-direction: column;
                gap: 5px;
            }

            .profile-view-btn {
                padding: 6px 10px;
                font-size: 0.7rem;
            }
        }
    </style>

    <div class="messages-container">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">💌 Messages</h1>
                        <p class="marathi-font mb-0">Your conversations and discussions</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBackToDashboard" runat="server" Text="🏠 Back to Dashboard" 
                            CssClass="btn btn-light marathi-font" OnClick="btnBackToDashboard_Click" />
                    </div>
                </div>
            </div>

            <!-- Messages Layout -->
            <div class="messages-layout">
                <!-- Conversations Sidebar -->
                <div class="conversations-sidebar">
                    <div class="conversations-header">
                        <div class="search-box">
                            <asp:TextBox ID="txtSearchConversations" runat="server" CssClass="search-input marathi-font" 
                                placeholder="Search conversations..."></asp:TextBox>
                            <span class="search-icon">🔍</span>
                        </div>
                        <asp:Button ID="btnNewMessage" runat="server" Text="➕ New Message" 
                            CssClass="btn btn-primary btn-sm w-100 marathi-font" OnClick="btnNewMessage_Click" />
                    </div>
                    
                    <div class="conversations-list" id="conversationsList">
                        <asp:Repeater ID="rptConversations" runat="server" OnItemDataBound="rptConversations_ItemDataBound">
                            <ItemTemplate>
                                <div class="conversation-item" data-userid='<%# Eval("OtherUserID") %>'>
                                    <asp:Image ID="imgUser" runat="server" CssClass="conversation-avatar" 
                                        ImageUrl='<%# GetUserPhotoUrl(Eval("OtherUserID")) %>'
                                        onerror="this.src='Images/default-profile.jpg'"
                                        onclick='viewProfileFromConversation(<%# Eval("OtherUserID") %>)' />
                                    
                                    <div class="conversation-content">
                                        <div class="conversation-header">
                                            <div class="conversation-name marathi-font" 
                                                 onclick='viewProfileFromConversation(<%# Eval("OtherUserID") %>)'>
                                                <%# Eval("FullName") %>
                                                <span class="online-status" style='display: <%# (new Random().Next(0,100) > 50 ? "inline-block" : "none") %>'></span>
                                            </div>
                                            <div class="conversation-time marathi-font">
                                                <%# FormatTime(Eval("LastMessageDate")) %>
                                            </div>
                                        </div>
                                        <div class="conversation-preview marathi-font" 
                                             onclick='selectConversation(this, <%# Eval("OtherUserID") %>)'>
                                            <%# Eval("LastMessage") %>
                                        </div>
                                    </div>
                                    
                                    <asp:Panel ID="pnlUnreadCount" runat="server" CssClass="unread-badge" 
                                        Visible='<%# Convert.ToInt32(Eval("UnreadCount")) > 0 %>'>
                                        <asp:Label ID="lblUnreadCount" runat="server" Text='<%# Eval("UnreadCount") %>'></asp:Label>
                                    </asp:Panel>

                                    <!-- View Profile Button in Conversation List -->
                                    <button class="conversation-profile-btn marathi-font" 
                                            onclick='viewProfileFromConversation(<%# Eval("OtherUserID") %>)'
                                            title="View Profile">
                                        👁️ View
                                    </button>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="pnlNoConversations" runat="server" Visible="false" CssClass="empty-chat">
                            <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                            <h4 class="marathi-font text-muted">No conversations yet</h4>
                            <p class="marathi-font text-muted">Start a conversation by sending a new message</p>
                        </asp:Panel>
                    </div>
                </div>
                
                <!-- Chat Area -->
                <div class="chat-area">
                    <asp:Panel ID="pnlActiveChat" runat="server" Visible="false">
                        <!-- Chat Header -->
                        <div class="chat-header">
                            <div class="chat-user-info" onclick='viewProfile(<%= hdnActiveUserID.Value %>)'>
                                <asp:Image ID="imgActiveUser" runat="server" CssClass="chat-user-avatar" 
                                    onerror="this.src='Images/default-profile.jpg'" />
                                <div class="chat-user-details">
                                    <h5 class="marathi-font">
                                        <asp:Label ID="lblActiveUserName" runat="server" Text=""></asp:Label>
                                        <span class="online-status" id="activeUserOnlineStatus"></span>
                                    </h5>
                                    <p class="marathi-font">
                                        <asp:Label ID="lblActiveUserDetails" runat="server" Text=""></asp:Label>
                                    </p>
                                    <small class="view-profile-link marathi-font">
                                        <i class="fas fa-external-link-alt"></i> View Profile
                                    </small>
                                </div>
                            </div>
                            <div class="chat-actions">
                                <button class="profile-view-btn marathi-font" 
                                        onclick='viewProfile(<%= hdnActiveUserID.Value %>)'>
                                    <i class="fas fa-user"></i> Profile
                                </button>
                                <button class="chat-action-btn" title="Phone Call">
                                    <i class="fas fa-phone"></i>
                                </button>
                                <button class="chat-action-btn" title="More Options">
                                    <i class="fas fa-ellipsis-v"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Messages Container -->
                        <div class="messages-container-scroll" id="messagesScrollContainer">
                            <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                                <ItemTemplate>
                                    <div class='message <%# IsSentMessage(Convert.ToInt32(Eval("FromUserID"))) ? "message-sent" : "message-received" %>'>
                                        <div class="message-text marathi-font">
                                            <%# Eval("MessageText") %>
                                            <!-- Add View Profile link in received messages -->
                                            <%# !IsSentMessage(Convert.ToInt32(Eval("FromUserID"))) ? 
                                                "<br/><small class=\"view-profile-link\" onclick=\"viewProfile(" + Eval("FromUserID") + ")\">👁️ View Profile</small>" : "" %>
                                        </div>
                                        <div class="message-time">
                                            <%# FormatTime(Eval("SentDate")) %>
                                            <asp:Label ID="lblReadStatus" runat="server" 
                                                Visible='<%# IsSentMessage(Convert.ToInt32(Eval("FromUserID"))) %>'
                                                Text='<%# Convert.ToBoolean(Eval("IsRead")) ? "✅" : "✉️" %>'></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            
                            <asp:Panel ID="pnlNoMessages" runat="server" Visible="false" CssClass="empty-chat">
                                <i class="fas fa-comment-slash fa-4x text-muted mb-3"></i>
                                <h4 class="marathi-font text-muted">Start Conversation</h4>
                                <p class="marathi-font text-muted">Start a conversation by sending the first message</p>
                                <button class="btn btn-primary marathi-font mt-3" 
                                        onclick='viewProfile(<%= hdnActiveUserID.Value %>)'>
                                    <i class="fas fa-user"></i> View Profile
                                </button>
                            </asp:Panel>
                        </div>
                        
                        <!-- Message Input Area -->
                        <div class="message-input-area">
                            <div class="message-input-container">
                                <asp:TextBox ID="txtMessage" runat="server" CssClass="message-input marathi-font" 
                                    TextMode="MultiLine" Rows="1" placeholder="Type your message..."
                                    onkeypress="return checkEnter(event)"></asp:TextBox>
                                <asp:Button ID="btnSendMessage" runat="server" Text="➤" 
                                    CssClass="send-btn" OnClick="btnSendMessage_Click" />
                            </div>
                            <div class="text-center mt-2">
                                <small class="marathi-font text-muted">
                                    After sending message 
                                    <span class="view-profile-link" onclick='viewProfile(<%= hdnActiveUserID.Value %>)'>
                                        click here to view profile
                                    </span>
                                </small>
                            </div>
                        </div>
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlNoChatSelected" runat="server" Visible="true" CssClass="empty-chat">
                        <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                        <h4 class="marathi-font text-muted">Select Conversation</h4>
                        <p class="marathi-font text-muted">Select a conversation from the left list or send a new message</p>
                        <p class="marathi-font text-info">
                            <i class="fas fa-info-circle"></i> 
                            After reading the message, click on the user's name or profile button to view profile
                        </p>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnActiveUserID" runat="server" />
    <asp:HiddenField ID="hdnRefreshMessages" runat="server" Value="false" />

    <script>
        // View Profile from active chat
        function viewProfile(userID) {
            if (userID && userID != '0') {
                window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
            } else {
                showNotification('Select a conversation to view profile', 'error');
            }
        }

        // View Profile from conversation list
        function viewProfileFromConversation(userID) {
            if (userID && userID != '0') {
                window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
            }
        }

        // Select conversation
        function selectConversation(element, userID) {
            // Remove active class from all conversations
            document.querySelectorAll('.conversation-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Add active class to selected conversation
            element.closest('.conversation-item').classList.add('active');
            
            // Store active user ID
            document.getElementById('<%= hdnActiveUserID.ClientID %>').value = userID;
            
            // Trigger postback to load messages
            __doPostBack('loadMessages', userID);
        }

        // Check for Enter key in message input
        function checkEnter(event) {
            if (event.keyCode === 13 && !event.shiftKey) {
                event.preventDefault();
                document.getElementById('<%= btnSendMessage.ClientID %>').click();
                return false;
            }
            return true;
        }

        // Auto-resize textarea
        function autoResize(textarea) {
            textarea.style.height = 'auto';
            textarea.style.height = (textarea.scrollHeight) + 'px';
        }

        // Scroll to bottom of messages
        function scrollToBottom() {
            const container = document.getElementById('messagesScrollContainer');
            if (container) {
                container.scrollTop = container.scrollHeight;
            }
        }

        // Manual refresh messages (user initiated)
        function refreshMessages() {
            const activeUserID = document.getElementById('<%= hdnActiveUserID.ClientID %>').value;
            if (activeUserID && activeUserID !== '0') {
                __doPostBack('loadMessages', activeUserID);
            }
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function () {
            // Auto-resize message input
            const messageInput = document.getElementById('<%= txtMessage.ClientID %>');
            if (messageInput) {
                messageInput.addEventListener('input', function () {
                    autoResize(this);
                });

                // Set focus to message input
                setTimeout(() => {
                    messageInput.focus();
                }, 500);
            }

            // Scroll to bottom on initial load
            setTimeout(scrollToBottom, 100);

            // Add click handlers for all view profile links
            document.querySelectorAll('.view-profile-link').forEach(link => {
                link.style.cursor = 'pointer';
            });

            console.log('Messages page loaded - Profile viewing enabled');
        });

        // Notification function
        function showNotification(message, type) {
            try {
                // Remove existing notifications
                const existingNotifications = document.querySelectorAll('.custom-notification');
                existingNotifications.forEach(notif => {
                    if (document.body.contains(notif)) {
                        document.body.removeChild(notif);
                    }
                });

                const notification = document.createElement('div');
                notification.className = 'custom-notification';

                // Style the notification
                notification.style.position = 'fixed';
                notification.style.top = '20px';
                notification.style.right = '20px';
                notification.style.padding = '15px 20px';
                notification.style.borderRadius = '10px';
                notification.style.color = 'white';
                notification.style.fontWeight = 'bold';
                notification.style.zIndex = '10000';
                notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
                notification.style.transition = 'all 0.3s ease';
                notification.style.maxWidth = '400px';
                notification.style.wordWrap = 'break-word';
                notification.style.fontFamily = "'Nirmala UI', 'Arial Unicode MS', sans-serif";

                if (type === 'success') {
                    notification.style.background = '#28a745';
                    notification.innerHTML = '✅ ' + message;
                } else if (type === 'error') {
                    notification.style.background = '#dc3545';
                    notification.innerHTML = '❌ ' + message;
                } else if (type === 'info') {
                    notification.style.background = '#17a2b8';
                    notification.innerHTML = 'ℹ️ ' + message;
                }

                document.body.appendChild(notification);

                // Auto remove after 5 seconds
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        notification.style.opacity = '0';
                        notification.style.transform = 'translateX(100px)';
                        setTimeout(() => {
                            if (document.body.contains(notification)) {
                                document.body.removeChild(notification);
                            }
                        }, 300);
                    }
                }, 5000);

                // Also allow manual close on click
                notification.addEventListener('click', function () {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                });

            } catch (e) {
                console.error('Notification error:', e);
                // Fallback to alert
                alert(message);
            }
        }

        // Add refresh button to chat actions
        function addRefreshButton() {
            const chatHeader = document.querySelector('.chat-header .chat-actions');
            if (chatHeader) {
                const refreshBtn = document.createElement('button');
                refreshBtn.className = 'chat-action-btn';
                refreshBtn.title = 'Refresh Messages';
                refreshBtn.innerHTML = '<i class="fas fa-sync-alt"></i>';
                refreshBtn.onclick = refreshMessages;
                chatHeader.appendChild(refreshBtn);
            }
        }

        // Call this when chat is loaded
        setTimeout(addRefreshButton, 1000);

        // Function to handle message sent and then view profile
        function sendMessageAndViewProfile() {
            const messageInput = document.getElementById('<%= txtMessage.ClientID %>');
            const sendButton = document.getElementById('<%= btnSendMessage.ClientID %>');

            if (messageInput && messageInput.value.trim() !== '') {
                // Store the message
                const message = messageInput.value;

                // Send message
                sendButton.click();

                // After sending, wait a bit and then redirect to profile
                setTimeout(() => {
                    const activeUserID = document.getElementById('<%= hdnActiveUserID.ClientID %>').value;
                    if (activeUserID && activeUserID !== '0') {
                        window.location.href = 'ViewUserProfile.aspx?UserID=' + activeUserID;
                    }
                }, 1000);
            }
        }
    </script>
</asp:Content>