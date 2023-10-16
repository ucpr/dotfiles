FROM denoland/deno:1.37.2

WORKDIR config

COPY . .

CMD ["bash"]
