FROM denoland/deno:2.3.6

WORKDIR config

COPY . .

CMD ["bash"]
