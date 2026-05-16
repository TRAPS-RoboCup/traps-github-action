FROM ros:humble-ros-base@sha256:5417e56962ff6e15d4cf9b2f78a71a78f3901f47cd78696b575b7eecdb54eb78

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
