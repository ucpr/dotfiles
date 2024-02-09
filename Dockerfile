FROM denoland/deno:1.40.4

WORKDIR config

COPY . .

CMD ["bash"]
